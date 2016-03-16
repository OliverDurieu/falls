require 'spec_helper'

describe Friend, :type => :model do
	it "should belong to  car" do
		should belong_to (:user)
	end
end
