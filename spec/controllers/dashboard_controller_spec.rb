require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do


	it "should submit on contact us" do
    params = {firstname: "alex", lastname: "sami", email: "alex@sami.com", message: "this is my first message"}
  	get :contact_us_submit , params
  	expect(response).should redirect_to(root_path)
  end
end 