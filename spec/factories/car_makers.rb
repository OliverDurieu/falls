# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :car_maker do
		Car
		CarModel
	end
end
