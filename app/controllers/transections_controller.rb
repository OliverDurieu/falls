class TransectionsController < ApplicationController
  before_action :validate_payment_params, only: [:payment]

  def payment
    ride = Ride.find(params[:ride_id])
    stripe_token = params[:stripe_card_token]
    qty = params[:quantity].to_i

    charge = StripeApi.instance.charge(qty * ride.total_price.to_i,
                                       params[:stripe_card_token],
                                       current_user, ride.id)
    ch = charge.to_hash
    if ch[:paid] == true && (ch[:status] == 'paid' || ch[:status] == 'succeeded')
      
      booking = current_user.generate_booking(ride, qty)
      # decrement_no_of_available_seats on the creation of booking
      # creates booking notification on the creation of booking

      transaction = booking.generate_transaction(ch, stripe_token)
      # send email to passenger on the creation of transaction

      updated_ride = transaction.ride

      respond_to do |format|
        format.json { render :json => {seats_availabe: updated_ride.number_of_seats ,success: true, booking_token: booking.token, paid_amount: transaction.amount.to_f / 100 }}
      end
    else
      respond_to do |format|
        format.json { render :json => {:success => false, reason: ch['reason']}}
        format.html do
          flash[:alert] = 'Transaction not succeeded'
          redirect :back
        end
      end
    end
  end

  def refund
    puts params.to_yaml
    transection = Transection.find(params[:id])
    if transection.present?
      begin
        ch = Stripe::Charge.retrieve(transection.t_id)
        refund = ch.refunds.create
        flash[:success] = "Done"
      rescue => e
        body = e.json_body
        err  = body[:error]
        flash[:alert] = err[:message]
      end
    else
      flash[:alert] = "Failed"
    end
    redirect_to :back
  end

  private
    def validate_payment_params
      ride = Ride.find(params[:ride_id])
      stripe_token = params[:stripe_card_token]
      qty = params[:quantity].to_i

      unless stripe_token.present? && qty <= ride.number_of_seats && qty > 0
        respond_to do |format|
          format.json { render :json => {:success => false, reason: 'Invalid number of seats for this ride'}}
          format.html do
            flash[:alert] = 'connection error: Please try after some time'
            redirect :back
          end
        end
      end
    end
end
