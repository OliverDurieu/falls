require 'rails_helper'

RSpec.describe MessageThread, :type => :model do
	it "should belong to  ride" do
		should belong_to (:ride)
	end
	it "should belong to  user" do
		should belong_to (:user)
	end
	it "should have many messages" do
		should have_many (:messages)
	end
	
end
