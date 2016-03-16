require 'spec_helper'

describe Route, :type => :model do
	it { should belong_to(:source).class_name('Location') }
	it { should belong_to(:destination).class_name('Location') }
	it "should belong to  ride" do
		should belong_to (:ride)
	end
end
