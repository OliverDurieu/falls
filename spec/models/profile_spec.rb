require 'spec_helper'

describe Profile do
	 it { should_not validate_presence_of(:photo) }
	it "should belong to user" do
		should belong_to (:user)
	end
	it "should belong to country" do
		should belong_to (:country)
	end
	it "should displayed as 1" do
		profile =FactoryGirl.create(:profile)
	    expect(profile.mini_bio).to eq("MyText")
	end
end