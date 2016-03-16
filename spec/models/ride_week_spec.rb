require 'spec_helper'

describe RideWeek, :type => :model do
	it "should belong to  ride" do
		should belong_to (:ride)
	end
end
