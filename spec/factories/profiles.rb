# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :profile do
		User
		Country
		mini_bio "MyText"
	end
end