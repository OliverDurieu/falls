 # Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :notification do
		User
	end
end
