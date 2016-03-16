require 'rails_helper'

RSpec.describe EmailAlert, :type => :model do
  it "should belong to  car" do
		should belong_to (:user)
	end
end
