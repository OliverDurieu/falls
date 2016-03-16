require 'spec_helper'

describe CarCategory, :type => :model do
	it "should have many cars" do
			should have_many (:cars)
	end
end
