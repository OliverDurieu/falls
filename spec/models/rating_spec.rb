require 'rails_helper'

RSpec.describe Rating, :type => :model do
	it { should validate_presence_of(:star) }
  it { should ensure_length_of(:comment).is_at_least(5)}
  it "should belong to  user" do
		should belong_to (:user)
	end
end
