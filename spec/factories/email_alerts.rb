# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_alert do
  	User
		travel_date "%{DateTime.now}"
  end
end
