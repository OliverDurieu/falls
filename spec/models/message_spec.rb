require 'rails_helper'

RSpec.describe Message, :type => :model do
  	it "should belong to  meesage thread" do
		should belong_to (:message_thread)
	end
end
