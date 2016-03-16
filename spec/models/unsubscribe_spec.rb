require 'spec_helper'

describe Unsubscribe, :type => :model do
	it "should belong to  user" do
		should belong_to (:user)
	end
	# it "should belong to  user" do
	# 	should belong_to (:user)
	# end
end
