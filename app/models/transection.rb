class Transection < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  belongs_to :booking
  after_create :send_email

  private
    def send_email
      transaction = self
      if transaction.status == 'paid' || transaction.status == 'succeeded'
        mandrill = MandrillMailer.new
        mandrill.booking_details(transaction.user, transaction.ride, transaction.booking.no_of_seats_booked)
        mandrill.driver_booking_notification(transaction.ride, transaction.booking)
      end
    end
end
