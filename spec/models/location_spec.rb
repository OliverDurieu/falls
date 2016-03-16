require 'spec_helper'

describe Location, :type => :model do
	it { should have_one(:source_route).class_name('Route') }
	it { should have_one(:destination_route).class_name('Route') }	
	it "should belong to  ride" do
		should belong_to (:ride)
	end

	it { should validate_presence_of(:address) }

end
