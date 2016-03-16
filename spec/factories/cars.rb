  # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :car do
		CarCategory
		CarMaker
		CarModel
		User
		Color
		Ride
	end
end
 