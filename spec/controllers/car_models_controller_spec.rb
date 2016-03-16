require 'rails_helper'
RSpec.describe CarModelsController, :type => :controller do
  
  it "should get index of car models" do
   	car_maker = FactoryGirl.create(:car_maker)
  	get :index, car_maker_id: car_maker.id
  	expect(response).to have_http_status(:success)
  end  
end
