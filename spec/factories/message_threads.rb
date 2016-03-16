# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_thread do
    sender_id 1
    receiver_id 1
    ride_id 1
    Ride
    User
    Message
  end
end
