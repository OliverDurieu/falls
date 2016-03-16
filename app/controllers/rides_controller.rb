class RidesController < ApplicationController
  before_action :authenticate_user!, except: [:rides_info]

  before_action :set_header, only: [:show, :rides_info, :successfully_posted_rides, :offer_seat_1]
  before_action :set_message_icon_flag, only: [:show, :rides_info, :successfully_posted_rides, :offer_seat_1]
	before_action :set_ride, only: [:show, :update, :contact_to_the_driver]
	# before_action :create_offer_2, only: [:share_on_facebook]
	before_action :set_user_ride_or_default_ride, only: [:edit, :offer_seat_2, :destroy, :set_car, :archive]

  # before_action :check_driver_verification, only: [:offer_seat_1]

  layout 'offer_ride', only: [:offer_seat_1, :rides_info, :show]

  include RidesC::CrudMethods
  include RidesC::CalculationMethods
  include RidesC::SocialMethods
  include RidesC::AjaxMethods
  include RidesC::PrivateMethods
end

