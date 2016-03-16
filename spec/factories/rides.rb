# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
	factory :ride do
		 Visitor
		 Car
		 User
		 Route
		 Location
		 MessageThread
		 RideWeek
		 number_of_seats 3
		 max_luggage_size 2
		 # leaving_delay "#{n}"
		 departure_date DateTime.now.new_offset(0)
		 return_date DateTime.now.tomorrow.new_offset(0)
	end
end
 