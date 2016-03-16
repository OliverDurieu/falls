FactoryGirl.define do
  factory :user do
  	PhoneNumber
  	Ride
  	Profile
  	Preference
  	Notification
  	Unsubscribe
  	Visitor
  	MessageThread
  	EmailAlert
  	Friend
  	Rating
  	Car
  	gender "Male"
  	birth_year "1996"
    password "alex1234"
    password_confirmation "alex1234"
    sequence(:first_name) { |n| "foo#{n}" }
    sequence(:last_name) { |n| "foo#{n}" }

    email { "#{first_name}@example.com" }
  end
end
