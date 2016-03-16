require 'spec_helper'

describe Preference, :type => :model do
	it "should belong to  car" do
		should belong_to (:user)
	end
end
