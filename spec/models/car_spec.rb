require 'spec_helper'

describe Car, :type => :model do
		 it { should validate_presence_of(:car_maker_id) }
		 it { should validate_presence_of(:car_model_id) }
		 it { should validate_presence_of(:color_id) }
		 it { should validate_presence_of(:car_category_id) }
	
	it "should belong to car catrgory" do
		should belong_to (:car_category)
	end
	it "should belong to car maker" do
		should belong_to (:car_maker)  
	end
	it "should belong to car model" do
		should belong_to (:car_model)
	end
	it "should belong to car color" do
		should belong_to (:color)

	end
	it "should belong to car maker" do
		should belong_to (:user)
	end
	it "should  has one ride" do
		should have_one (:ride)
	end
end
