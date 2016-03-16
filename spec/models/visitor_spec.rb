require 'rails_helper'

RSpec.describe Visitor, :type => :model do
	it "should belong to  ride" do
		should belong_to (:ride)
	end
	it "should belong to  user" do
		should belong_to (:user)
	end
end
