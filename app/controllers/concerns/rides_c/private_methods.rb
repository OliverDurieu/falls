# Rides
class RidesC

  module PrivateMethods
    extend ActiveSupport::Concern

    private

    def set_ride
      @ride = Ride.find(params[:id])
    end

    def set_user_ride_or_default_ride
      @ride = Ride.find(params[:id])
      if  @ride.user_id.present? && @ride.user_id != current_user.id
        flash[:danger] = "your are not authorize to access this page."
        redirect_to root_path
      end
    end

    def offer_1_ride_params
      # params[:ride][:departure_time] = params[:ride][:departure_date].to_time
      params.require(:ride).permit(
          :departure_date,
          :return_date,
          :is_recurring_trip,
          :is_round_trip,
          :number_of_seats,
          :routing_required,
          :enable_locations_validation,
          :total_price,
          :car_id,
          :leaving_delay,
          :detour_preferences,
          :total_distance,
          :total_time,
          :full_completed,
          locations_attributes: [:id, :address, :longitude, :latitude, :sequence, :ride_type],
          ride_weeks_attributes: [:id, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :date_type],
          ride_months_attributes: [:id, :jan, :feb, :mar, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec, :date_type]
      )
    end

    def offer_2_ride_params
      if params[:ride][:car_id] && params[:ride][:car_id].nil?
        params[:ride][:car_id] = 0
      end
      params.require(:ride).permit(:general_details, :specific_details, :your_car, :number_of_seats, :max_luggage_size, :is_details_same, :leaving_delay, :detour_preferences, :accept_tos, :car_id, :full_completed, :total_distance, :total_time, :enable_routes_validation, routes_attributes: [:id, :price])
    end

    def build_init_locations
      @source = @ride.locations.build(ride_type: GlobalConstants::Locations::RIDE_TYPES[:source])
      @sub_routes = @ride.locations.build(ride_type: GlobalConstants::Locations::RIDE_TYPES[:sub_route])
      @destination = @ride.locations.build(ride_type: GlobalConstants::Locations::RIDE_TYPES[:destination])
    end

    def build_init_recuring_weeks
      @outbound_week = @ride.ride_weeks.build(date_type: GlobalConstants::Ride_weeks::DATE_TYPES[:outbound_week])
      @return_week = @ride.ride_weeks.build(date_type: GlobalConstants::Ride_weeks::DATE_TYPES[:return_week])
    end

    def build_init_recuring_months
      @outbound_month = @ride.ride_months.build(date_type: GlobalConstants::Ride_months::DATE_TYPES[:outbound_month])
      @return_month = @ride.ride_months.build(date_type: GlobalConstants::Ride_months::DATE_TYPES[:return_month])
    end

    def active
      @rides = current_user.rides
    end

    def set_date(trip)
      trip.each do |t|
        rride = Ride.find(t.ride_id)
        if t.dir == "st"
          t.date = rride.departure_date
        else
          if rride.return_date
            t.date = rride.return_date
          else
            t.date = rride.departure_date
          end
        end
      end
    end

    def delete_trip(trip)
      puts trip.inspect
      puts trip.count
      trip.each do |t|
          if t.date.to_i < Time.now.to_i
            trip.delete(t)
          end
        end
    end

    def sort_trips(trip)
      if params[:order_by]=="departure_date DESC"
     #   trip = trip.sort_by { |date| date.date }.reverse
        trip = trip.sort_by { |date| date.date }
      elsif  params[:order_by]=="departure_date ASC"
        trip = trip.sort_by { |date| date.date }
      elsif  params[:order_by]=="total_price ASC"
    #    trip = trip.sort_by { |trip_price| trip_price.trip_price }
        trip = trip.sort_by { |date| date.date }
      else
    #    trip = trip.sort_by { |date| date.date }.reverse
        trip = trip.sort_by { |date| date.date }
      end
    end


    def search_rides
      if params[:start_time].present? && params[:last_time].present?
        start_time = "#{params[:start_time]}".to_i
        last_time = "#{params[:last_time]}".to_i
        @trip = @trip.select { |trip| trip.date.try(:time).try(:hour) || 0 >= start_time }
        @trip = @trip.select { |trip| trip.date.try(:time).try(:hour) || 0 <= last_time }
        #@trip.rid
        @rides = @rides.where("Extract(HOUR from rides.departure_date) between ? and ? OR Extract(HOUR from rides.return_date) between ? and ?", start_time, last_time, start_time, last_time)
      end

      if params[:departure_date].present?
        dep_date = params[:departure_date].to_date
        @trip = @trip.select { |trip| trip.date.to_date == dep_date.to_date }
        @rides = @rides.where("rides.departure_date >= ? AND rides.departure_date <= ?", dep_date, "#{dep_date} 23:59:59.996")
      end
      @rides_with_photo = Ride.joins(user: :profile).where("users.id IN (?) AND profiles.photo IS NOT NULL", @trip.map(&:user_id))
      @count = 0
      @trip.each do |t|
        @rides_with_photo.each do |r|
          if t.ride_id == r.id
            @count += 1
            break
          end
        end
      end
    end


    def send_notifications
      if current_user.notifications.notification_status('ride_offer_published')
        mandrill = MandrillMailer.new
        mandrill.send_published_confirmation_mandrill(@ride,root_path)
      end
    end
    
    def after_saving_functions
      send_notifications
      @ride.send_nearby_users_msg
    end

    def check_driver_verification
      redirect_to driver_verifications_path unless current_user.verified_driver?
    end
  end
end
