# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :location do
		Ride
    address "Australia"
    latitude  -25.274398
    longitude 133.775136
	end
end
