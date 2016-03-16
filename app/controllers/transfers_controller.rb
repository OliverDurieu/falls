class TransfersController < ApplicationController

  def transfer_funds 
   booking_token = params[:booking_token]
   if booking_token.present?
     booking = Booking.where(:token => params[:booking_token]).where(:payment_recieved => false).first
     if booking.present?
       if booking.ride.present?
        if booking.ride.user.present?
          if booking.ride.user == current_user
            amount = (booking.ride.total_price * booking.no_of_seats_booked).to_i
            # amount = amount * GlobalConstants::LAMULE_TRANSFER_PERCENTAGE
            app_fee = amount - amount * GlobalConstants::LAMULE_TRANSFER_PERCENTAGE
            create_stripe_transfer(amount.to_i,booking, (app_fee * 100).to_i)
          else
            flash[:alert] = 'You are not the creator of this ride'
          end  
        else
        end  
       else
        flash[:alert] = 'This ride no longer exists'
       end 
      else
       flash[:alert] = 'Sorry, no booking against this token found or the booking has already been paid for'
      end 
    else
      flash[:alert] = 'Please provide the booking token given to you by the passenger(s)'
    end  
   redirect_to profile_credit_card_path 
  end  

  def revert_transfer
    transfer = Transfer.where(:transfer_id => params[:id]).first
    tr = Stripe::Transfer.retrieve(params[:id])
    transfer_params = tr.to_hash
    # reversal = tr.reversals.create
    reversal = tr.reversals.create(
                :amount => transfer_params[:amount],
                :refund_application_fee => true
              )

    puts "Transfer reverted successfully!"
    puts "=-=-=-=-=-=-=-=-=-=-=-"
    puts reversal.to_hash

    ch = Stripe::Charge.retrieve(transfer.booking.transection.t_id)
    refund = ch.refunds.create
    puts "Card refunded successfully!"
    puts "=-=-=-=-=-=-=-=-=-=-=-"
    puts refund.to_hash
    flash[:notice] = 'Success, the payment has been reverted to the card it was charged from'
    redirect_to :back
  end

  protected
  def create_stripe_transfer(amount,booking, app_fee)
    begin
      transfer_response = Stripe::Transfer.create(
        :amount => amount*100, # transfer amount in cents
        :currency => "usd",
        :destination => booking.ride.user.stripe_id,
        :application_fee => app_fee
      )
      puts "====Transfer====Complete====="
      puts transfer_response.to_yaml
      booking.update_column(:payment_recieved, true)
      flash[:notice] = 'Success, an amount of '+amount.to_s+"$, has been transfered to your stripe account"
      res = transfer_response.to_hash
      Transfer.create(booking_id: booking.id,transfer_id: res[:id], amount: res[:amount], application_fee_id: res[:application_fee], ride_id: booking.ride.id)
    rescue => e
      flash[:alert] = e
    end
  end 

end
