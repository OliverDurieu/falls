require 'spec_helper'

describe Color, :type => :model do
	it "should have many cars" do
		should have_many (:cars)
	end
end
