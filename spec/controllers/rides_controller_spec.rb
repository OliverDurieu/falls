 require 'rails_helper'

RSpec.describe RidesController, :type => :controller do

  before(:each)  do
		@current_user = FactoryGirl.create(:user)
    sign_in @current_user
    session[:current_user_id] = @current_user.id
  	@ride = FactoryGirl.create(:ride, user_id: @current_user.id)
    session[:current_ride_id] = @ride.id
    @ride.locations.create(address: "Australia", latitude:  -25.274398, longitude: 133.775136, ride_type: "source")
    @ride.locations.create(address: "Perth, Western Australia, Australia", latitude: -31.9530044, longitude: 115.8574693, ride_type: "destination")
   

  end
  
   it "should get index of rides" do
  	get :index
  	expect(response).to have_http_status(:success)
  end  

  it "should get previous rides" do
   	get :previous_rides
  	expect(response).to have_http_status(:success)
  end
  
  it "should  archive rides" do
   	get :archive_rides
  	expect(response).to have_http_status(:success)
  end

  it "should show rides" do
  	@ride.routes.create()
  	@ride.locations.create()
  	@current_user.rides.create()
  	@current_user.rides[0] = @ride
    
   	get :show, id: @ride.id

		response.should render_template :show
  end
  
  it "should offer seat 1" do
   	get :offer_seat_1
  	expect(response).to have_http_status(:success)
  end
  
  it "should create an offer 1" do

    post :create_offer_1, {id: @ride.id, ride: {departure_date: DateTime.now,
      return_date: DateTime.now.tomorrow,
      is_recurring_trip: "",
      is_round_trip: true,
      number_of_seats: 3,
      routing_required: false,
      }}
    response.should_not be_success
  end
  it "should set car" do
  	car_maker = FactoryGirl.create(:car_maker)
  	car_model = FactoryGirl.create(:car_model)
  	car_color = FactoryGirl.create(:color)
  	car_category = FactoryGirl.create(:car_category)
  	@car = FactoryGirl.create(:car,car_maker_id: car_maker.id, car_model_id: car_model.id, color_id: car_color.id, car_category_id: car_category.id)
  	@car.ride = @ride
   	patch :set_car, id: @ride.id, ride: {car_id: @car.id}
  	expect(response).to redirect_to(ride_path(:id => @ride.id))
  end
  it "should share on facebook" do
    params = {id: @ride.id}
    get :share_on_facebook, params
    response.code.should == "302"
    
  end

  # it "should show rides info " do
  #   @ride = FactoryGirl.create(:ride, user_id: @current_user.id)
  #   @ride = FactoryGirl.create(:ride, user_id: @current_user.id)
  #   @ride = FactoryGirl.create(:ride, user_id: @current_user.id)
  #   @ride = FactoryGirl.create(:ride, user_id: @current_user.id)
  #   params = {ride_source: "Australia", ride_destination: "Perth, Western Australia, Australia" }
  #   get :rides_info, params
  #   expect(response).to redirect_to(ride_info_path)
  # end
end
