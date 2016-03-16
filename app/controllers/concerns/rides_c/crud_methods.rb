# Rides
class RidesC

  module CrudMethods
    extend ActiveSupport::Concern

    def index
      @rides = current_user.rides.where("departure_date >= (?) AND archieve = 0",Time.now)
      @p_rides = current_user.rides.where("departure_date <= (?) AND archieve = 0",Time.now)
      @a_rides = current_user.rides.where(archieve: 1)
    end

    # GET /rides/1
    # GET /rides/1.json
    def show
      @ride = Ride.find(params[:id])
      @user = @ride.user
      @source = @ride.source_location.get_route_name.partition(',').first
      @destination = @ride.destination_location.get_route_name.partition(',').first
      @time = @ride.departure_date
      @trip_price = @ride.total_price
      if params[:tour].present?
        @object = JSON.parse params[:tour]
        @source = @object['locations'][0] rescue @ride.destination_location.address
        @destination = @object['locations'][1] rescue @ride.source_location.address
        @trip_price  = @object['trip_price'] rescue @ride.total_price
        if @object['dir'] == "rev"
          if @ride.return_date
            @time = @ride.return_date
          else
            @time = @ride.departure_date
          end
        end
      end
      @self_user = current_user && current_user.id == @user.id ? true : false
      @ride.add_visitor(current_user.id) if current_user.present?
    end

    def set_car
      if @ride.update(car_id: params[:ride][:car_id])
        redirect_to ride_path(@ride.id)
      else
        redirect_to ride_path(@ride.id)
      end
    end

    def offer_seat_1
        @ride = Ride.new
        build_init_locations
        build_init_recuring_weeks
        build_init_recuring_months
        render 'offer_seat_1'
    end

    def create_offer_1
      puts offer_1_ride_params.to_yaml
      if user_signed_in?
        @ride = current_user.rides.build(offer_1_ride_params)
      else
        @ride = Ride.new(offer_1_ride_params)
      end
      respond_to do |format|
        if @ride.save!
          # Analytics.track(user_id: current_user.id, event: 'Created a ride')
          @ride.set_routes(params[:ride][:routes_attributes])
          @ride.handle_return_date_and_recurring_weeks
          after_saving_functions
          format.html { redirect_to successfully_posted_rides_ride_path(@ride) }
          format.json { render :show, status: :created, location: @ride }
        else
          # build_init_locations
          format.html {
            flash[:danger] = @ride.errors
            render 'offer_seat_1'
          }
          format.json { render json: @ride.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /rides/1
    # PATCH/PUT /rides/1.json
    def update
      respond_to do |format|
        if @ride.update(offer_1_ride_params)
          @ride.set_routes
          @ride.handle_return_date_and_recurring_weeks
          if current_user.notifications.notification_status('ride_offer_updated')
            mandrill = MandrillMailer.new
            mandrill.send_updated_ride_confirmation(@ride,root_path)
          end
          format.html { redirect_to "/#{@ride.id}/offer-seats/2" }
          format.json { render :show, status: :created, location: @ride }
        else
          format.html {
            flash[:danger] = "Please correct the error(s) listed below"
            render :edit
          }
          format.json { render json: @ride.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /rides/1
    # DELETE /rides/1.json
    def destroy
      mandrill = MandrillMailer.new
      mandrill.driver_ride_cancellation(@ride.user,@ride)
      @ride.destroy
      respond_to do |format|
        format.html { redirect_to archive_rides_rides_path, notice: 'Ride was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    def archive
      @ride.update(:archieve => 1)
      mandrill = MandrillMailer.new
      mandrill.driver_ride_cancellation(@ride.user,@ride)
      respond_to do |format|
        format.html { redirect_to dashboard_show_dashboard_path, notice: 'Ride was successfully destroyed.' }
        format.json { head :no_content }  
      end 
    end

    def add_seat
      @ride = Ride.find(params[:id])
      @ride.number_of_seats+=1
      @ride.save!
    end

    def delete_seat
      @ride = Ride.find(params[:id])
      @ride.number_of_seats-=1
      @ride.save!
      render "add_seat"
    end

    def duplicate_ride
      @ride = Ride.find(params[:id])
      if (params[:return_date].present? &&  params[:departure_date].to_time < params[:return_date].to_time) || params[:return_date].blank?
        @rid = @ride.dup
        @rid.save!
        @id=@rid.id
        if @rid.return_date.present?
          @rid.update(departure_date: params[:departure_date], return_date: params[:return_date])
        else
          @rid.update(departure_date: params[:departure_date])
        end
        @locations = Location.where(ride_id: params[:id])
        @locations.each do |location|
          loc = location.dup
          loc.save!
          loc.update(ride_id: @id)
        end
        @routes = Route.where(ride_id: params[:id])
        @routes.each do |route|
          rout = route.dup
          rout.save!
          rout.update(ride_id: @id)
        end
        redirect_to rides_path
      else
        flash[:danger] = "Please check all the fields are correctly filled to duplicate this trip."
        redirect_to rides_path
      end
    end

    def visitors
      @visitors = Visitor.where(:ride_id => params[:id]).limit(3)
      @ride = Ride.find(params[:id])
    end

    def rides_info
      puts "rides_params"
      puts params
      if params[:get].present?
        if params[:ride_source].present?
          location = Geocoder.search(params[:ride_source])
          @src1_lat = location[0].latitude
          @src1_lng = location[0].longitude
        end
        if params[:ride_destination].present?
          location = Geocoder.search(params[:ride_destination])
          @dst1_lat = location[0].latitude
          @dst1_lng = location[0].longitude
        end
        @src1 = params[:ride_source]
        @dst1 = params[:ride_destination]
        offer_seat_1
      elsif params[:search].present?
        puts 'rides_search_params_puts'
        puts params
        @rides_id = []
        @trip = []
        @trip = set_trip
        @rides_id = @trip.map(&:ride_id)
        # set date of trip
        @trip = set_date(@trip)
        #delete trip
        @trip = delete_trip(@trip)
        @trip = sort_trips(@trip)
        puts "======="
        puts @trip

        # check for profile_photo
        check_profile_picture
        #searching for rides of a trip
        search_rides
        temp_trip = @trip
        temp_trip.try(:each_with_index) do |trip, index|
          ride = Ride.find(trip.ride_id) rescue []
          if ride.is_round_trip.blank? && trip.dir == 'rev' || ride.departure_date.to_date < Time.now.to_date
            @trip.delete_at(index)
          end

        end
        if @rides_id == nil || @rides_id.blank? || @trip.blank? || (params[:ride_source] == ""  && params[:ride_destination] == "")   
          redirect_to URI.encode(new_email_alert_path+'?from='+params[:ride_source]+'&to='+params[:ride_destination])
        end
         #puts "===========================" 
         #puts @trip.inspect
        
         @today_trip=@trip
          puts "===========================" 
         puts @today_trip.count
          @other_trip=@trip
          puts "===========================" 
         puts @other_trip.count
           
      end        
    end



    def today_trips(trips)
       @t_trips=Array.new        
       trips.each do |trip| 
         @ride = Ride.find(trip.ride_id)
           if(@ride.departure_date.to_date == Time.now.to_date)
              @t_trips<<trip
           end
        end
      return @t_trips       
    end


    def other_trips(trips)
       @o_trips=Array.new        
       trips.each do |trip| 
         @ride = Ride.find(trip.ride_id)
           if(@ride.departure_date.to_date != Time.now.to_date)
              @o_trips<<trip
           end
        end
      return @o_trips       
    end



    def check_profile_picture
      @rides = Ride.where("rides.id IN (?) AND rides.user_id IS NOT NULL AND rides.departure_date > ? AND rides.full_completed > ?", @rides_id.uniq, Time.now, 0).order(params[:order_by])
      @source = params[:ride_source]
      @destination = params[:ride_destination]
      @pro_pho_check = false
      if params[:profile_photo] == "only"
        @rides_with_photo = Ride.joins(user: :profile).where("users.id IN (?) AND profiles.photo IS NOT NULL", @trip.map(&:user_id))
        @flag = 0
        @trip.each do |t|
          @rides_with_photo.each do |r|
            if t.ride_id == r.id
              @flag = 1
              break
            end
          end
          if @flag == 0
            @trip.delete(t)
          else
            @flag = 0
          end
        end
        @pro_pho_check = true
      end
    end

    def offer_seat_2
      @routes = @ride.routes
      @locations = @ride.locations.reorder('sequence ASC')
    end

    def successfully_posted_rides
      @ride = Ride.find(params[:id])
    end  

    def contact_to_the_driver
      if params[:private_msg].present?
        if !user_signed_in?
          redirect_to new_user_registration_path({ frid: @ride.id })
        else
          @user = @ride.user
          @ride.send_ride_offer_sms(current_user, @user, params[:private_msg])
          sending_message_thread_id = @ride.send_private_message(current_user, @user, params[:private_msg])
          #redirect_to message_thread_path(sending_message_thread_id)
            respond_to do |format|
            format.js   { }
            end
        end
      else
        redirect_to ride_path(@ride.id)
      end
    end
  end
end
