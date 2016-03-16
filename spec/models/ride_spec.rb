 require 'spec_helper'

describe Ride, :type => :model do
 	it { should validate_presence_of(:departure_date) }
  it { should validate_presence_of(:return_date) }
 it { should_not validate_presence_of(:number_of_seats) }
	it "should create a ride" do
		  ride = FactoryGirl.create(:ride)
		  expect(ride.departure_date)== (DateTime.now.new_offset(0))
	end
	it "should have many visitors" do
		should have_many (:visitors)
	end
	it "should belong to  car" do
		should belong_to (:car)
	end
	it "should belong to  user" do
		should belong_to (:user)
	end
	it "should have many routes" do
		should have_many (:routes)
	end
	
	it "should have many locations" do
		should have_many (:locations)
	end
	it "should have one message_threads" do
		should have_many (:message_threads)
	end
	
	it "should have many ride_weeks" do
		should have_many (:ride_weeks)
	end  
end
