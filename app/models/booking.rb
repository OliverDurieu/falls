class Booking < ActiveRecord::Base
	belongs_to :user
  belongs_to :ride
  has_one :booking_notification, dependent: :destroy
  has_one :transection
  has_one :transfer
  has_one :transfer_request
  after_create :decrement_no_of_available_seats
  after_create :generate_booking_notification

  def self.generate_booking_code
    token = loop do
      token = CodeGenerator::Generator.generate
      break token unless Booking.exists?(token: token)
    end
  end

  def generate_transaction(ch, token)
    booking = self
    booking.create_transection(t_id: ch[:id], token: token, paid: ch[:paid], 
                               status: ch[:status], amount: ch[:amount], currency: ch[:currency], 
                               last4: ch[:source][:last4], user_id: booking.user.id, ride_id: booking.ride.id, 
                               reason: 'Reserve Seat')
  end

  private
    def generate_booking_notification
      booking = self
      driver = booking.ride.user
      driver.booking_notifications.create(name: ride.locations.first.try(:address), sender_id: booking.user,
                                          ride_id: ride.id, seen: 0, booking_id: booking.id)
    end

    def decrement_no_of_available_seats
      booking = self
      number_of_seats = booking.ride.number_of_seats - booking.no_of_seats_booked
      booking.update_attribute(:status, 'accepted')
      booking.ride.update_attribute(:number_of_seats, number_of_seats)
    end
end
