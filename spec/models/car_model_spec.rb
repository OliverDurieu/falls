require 'spec_helper'

describe CarModel, :type => :model do
	 it "should  has many car" do
		should have_many (:cars)
	end
	it "should belong to car maker" do
		should belong_to (:car_maker)
	end
end
