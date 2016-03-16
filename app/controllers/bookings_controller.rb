class BookingsController < ApplicationController
require 'mandrill'

	def index
    #@past = false
		@bookings = current_user.bookings.where(ride_id: Ride.select("id").where("departure_date >= (?)",Time.now)).order("created_at DESC")
    #@bookings_count=@bookings.count
     #render json:@bookings_count
    @past_bookings = current_user.bookings.where(ride_id: Ride.select("id").where("departure_date < (?)",Time.now)).order("created_at DESC")
   # @past_bookings_count=@past_bookings.count
   # render json:@past_booking_count
  end

  def past_bookings
    @bookings = current_user.bookings.where(ride_id: Ride.select("id").where("departure_date < (?)",Time.now)).order("created_at DESC")
   # @past = true
    # @bookings = current_user.bookings.where(ride_id: Ride.select("id").where(id: current_user.bookings.select(:ride_id)).where("departure_date >= (?)",Time.now))
    render "index"
  end


  def accept
    booking = Booking.find(params[:id])
    if booking.present?
      qty = booking.no_of_seats_booked
      if booking.ride.present? && qty <= booking.ride.number_of_seats && qty > 0
        number_of_seats = booking.ride.number_of_seats - qty
        if number_of_seats < 0
          flash[:alert] = "All seats are booked"
        else
          booking.update_attribute(:status, "accepted")
          booking.ride.update_attribute(:number_of_seats, number_of_seats)
          flash[:notice] = "Booked"
        end
      end
    end
    redirect_to :back
  end

  def reject
    booking = Booking.find(params[:id])
    if booking.present?
      booking.update_attribute(:status, "rejected")
    end
    redirect_to :back
  end

  def show
    @booking = Booking.find(params[:id])
    @ride = @booking.ride
    @user = @ride.user
    @source = @ride.source_location.get_route_name
    @destination = @ride.destination_location.get_route_name
    @time = @ride.departure_date
    @trip_price = @ride.total_price
    @self_user = current_user && current_user.id == @user.id ? true : false
    @ride.add_visitor(current_user.id) if current_user.present?
  end

  def destroy
    booking = Booking.find(params[:id])
    if booking.present?
      if booking.ride.present? && booking.status == "accepted"
        seats = booking.no_of_seats_booked + booking.ride.number_of_seats
        booking.ride.update_attribute(:number_of_seats, seats)
      end
      BookingNotification.create(name: booking.ride.locations.first.try(:address), user_id: booking.ride.user_id, sender_id: current_user.id, ride_id: booking.ride.id, seen: 0)
      mandrill = MandrillMailer.new
      mandrill.ride_cancellation(current_user,booking.ride,booking.no_of_seats_booked)
      booking.destroy
      redirect_to bookings_path
    end
  end

  def update_seats number_of_seats
    ride = Ride.find(params[:ride_id])
    ride.save
  end
end
