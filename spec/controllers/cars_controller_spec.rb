 require 'rails_helper'

RSpec.describe CarsController, :type => :controller do

  before(:each)  do
		@current_user = FactoryGirl.create(:user)
    sign_in @current_user
    session[:current_user_id] = @current_user.id
  	@car_maker = FactoryGirl.create(:car_maker)
  	@car_model = FactoryGirl.create(:car_model)
  	@car_color = FactoryGirl.create(:color)
  	@car_category = FactoryGirl.create(:car_category)
  	@car = FactoryGirl.create(:car, car_maker_id: @car_maker.id, car_model_id: @car_model.id, color_id: @car_color.id, car_category_id: @car_category.id, user_id: @current_user.id)
  	
    session[:current_car_id] = @car.id
    @ride = FactoryGirl.create(:ride)
    session[:current_ride_id] = @ride.id
  	@car.ride = @ride

  end
	it "should make new car" do
  	get :new , rid: @ride.id, fr: ""
  	expect(response).to have_http_status(:success)
  end
  it "should update car " do
    put :update , id: @car.id, car: {car_maker_id: @car_maker.id, car_model_id: @car_model.id, color_id: @car_color.id, car_category_id: @car_category.id }
    response.code.should == "302"
  end
   it "should destroy car " do
    delete :destroy, id: @car.id
    expect(response).should redirect_to(cars_path)
  end
end 