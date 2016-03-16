require 'rails_helper'
 
RSpec.describe EmailAlertsController, :type => :controller do

  before(:each)  do
		@current_user = FactoryGirl.create(:user)
    sign_in @current_user
    session[:current_user_id] = @current_user.id
  	@email_alert = FactoryGirl.create(:email_alert)
  end
 
  # it "should update travel date" do
  #   @current_user.email_alerts.create()
  #   @current_user.email_alerts[0] = @email_alert
  #   get :update_travel_date, date: Date.today, id: @email_alert.id
  #   expect(response).to eq(DateTime.now.strftime("%A %d %B"))
  # end
end