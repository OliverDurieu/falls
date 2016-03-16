require 'spec_helper'

describe Notification, :type => :model do
	it "should belong to  user" do
		should belong_to (:user)
	end
end
