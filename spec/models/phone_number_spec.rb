require 'spec_helper'

describe PhoneNumber do
  it { should validate_presence_of(:body) }
	it "should belong to  user" do
		should belong_to (:user)
	end
	it "should belong to  country" do
		should belong_to (:country)
	end
end
