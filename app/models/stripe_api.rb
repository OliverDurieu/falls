require 'singleton'
# communication with Stripe
class StripeApi
  include Singleton

  class StripeError < StandardError
  end

  def charge(amount, token, user, ride_id)
    begin
      Stripe::Charge.create(:amount => amount.to_i * 100,
                            :currency => "usd",
                            :source => token,
                            :description => user.email
      )
    rescue Stripe::CardError => e
      createTransectionOnExcp e, amount, token, ride_id, user
    rescue Stripe::InvalidRequestError => e 
      createTransectionOnExcp e, amount, token, ride_id, user
    rescue Stripe::AuthenticationError => e
      createTransectionOnExcp e, amount, token, ride_id, user
    rescue Stripe::APIConnectionError => e
      createTransectionOnExcp e, amount, token, ride_id, user
    rescue Stripe::StripeError => e
      createTransectionOnExcp e, amount, token, ride_id, user
    rescue => e
      flash[:alert] = e
    end
  end

  def createTransectionOnExcp e,price, token, ride_id, user
    body = e.json_body
    err  = body[:error]
    # flash[:alert] = err[:message]
    transaction = createTransection err[:charge], err[:message], price, token, ride_id, user
    response = Hash.new
    response["paid"] = false
    response["status"] = 'Failed'
    response["reason"] = transaction.failure_message
    response
  end

  def createTransection charge, msg, price, token, ride_id, user
    Transection.create :t_id => charge, 
                       :token => token, 
                       :paid => false, 
                       :status => 'not paid', 
                       :amount => price, 
                       :user_id => user.id, 
                       :ride_id => ride_id, 
                       :reason => "Reserve Seat",
                       :failure_message => msg
  end
end
