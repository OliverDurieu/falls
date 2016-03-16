require 'spec_helper'

describe CarMaker, :type => :model do
	it "should have many cars" do
			should have_many (:cars)
		end
	it "should have many car models" do
		should have_many (:car_models)
	end
end
