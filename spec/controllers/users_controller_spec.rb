require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  before(:each)  do
  	@current_user = FactoryGirl.create(:user)
    sign_in @current_user
    session[:current_practice_id] = @urrent.id
  end
	# it 'Return json request in total_count' do
 #      get :total_count, format: :json
 #      expect(response).to have_http_status(:success)
	# end
end