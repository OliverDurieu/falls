class TransferRequestsController < ApplicationController

  def make_transfer_request
    @booking = Booking.find(params[:booking_id])     
    @ride = @booking.ride
    @success_status = 2
    if params[:code_for_payment].present? && @ride.user.id == current_user.id
      if params[:code_for_payment].to_s == @booking.token
        total_cost = @booking.ride.total_price * @booking.no_of_seats_booked
        t_request = @booking.create_transfer_request(user_id: @ride.user.id, amount: total_cost)
        t_request.create_transfer_transaction(user_id: @ride.user.id, amount: total_cost, status: "pending")
        @success_status = 1
      end
    end  
  end
end
