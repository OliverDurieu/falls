class ApplicationController < ActionController::Base
  
  rescue_from StandardError, with: :render_unknown_error
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found

  # Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :update_sanitized_params, if: :devise_controller?
	helper_method :resource, :resource_name, :devise_mapping
  # rescue_from Exception, :with => :render_error

	protected
	def set_ride_user
		ride = Ride.find(session[:ride_id]) rescue nil
		if ride.present?
			ride.update!(user_id: @user.id)
			ride.send_published_confirmation(root_path)
			flash[:notice] = t('rides.published', ride_id: ride.id)
			session.delete(:ride_id)
			scope = Devise::Mapping.find_scope!(@user)
			sign_in(scope, @user)
			redirect_to publication_ride_path(ride.id)
		else
			session.delete(:ride_id)
			redirect_to root_path
		end
	end

	def set_find_ride_user
		ride = Ride.find(session[:fride_id]) rescue nil
		if ride.present?
			scope = Devise::Mapping.find_scope!(@user)
			sign_in(scope, @user)
			if current_user.phone_number.body.present?
				session.delete(:fride_id)
				redirect_to contact_to_the_driver_ride_path(ride.id)
			else
				redirect_to fill_phone_path
			end
		else
			session.delete(:fride_id)
			redirect_to root_path
		end
	end

	def after_login_move_next_page
		next_url = session[:next_page]
		if next_url.present?
			scope = Devise::Mapping.find_scope!(@user)
			sign_in(scope, @user)
			session.delete(:next_page)
			redirect_to next_url
		end
	end

  def resource_name
  :user
  end

  def resource
  @resource ||= User.new
  end

  def devise_mapping
  @devise_mapping ||= Devise.mappings[:user]
  end

	# def locations_distance (lat1,lon1,lat2,lon2) {
	#   R = 6371; # km (change this constant to get miles)
	#   dLat = (lat2-lat1) * Math.PI / 180;
	#   dLon = (lon2-lon1) * Math.PI / 180;
	#   a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	#     Math.cos(lat1 * Math.PI / 180 ) * Math.cos(lat2 * Math.PI / 180 ) *
	#     Math.sin(dLon/2) * Math.sin(dLon/2);
	#   var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	#   var d = R * c;
	#   if d > 1
	#    return "#{ Math.round(d) }km";
	#   elsif d <= 1
	#    return "#{ Math.round(d*1000) }m";
	#   end
	#   return d;
	# end
	

	private

  def set_header
    @header_flag = true
  end

  def set_message_icon_flag
    @message_icon_flag = true
  end

	def update_sanitized_params
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:gender, :first_name, :last_name, :email, :password, :birth_year, :receive_updates, :ride_id) }
	end

	public
	def show_ratings(user)
		@driver = []
    	@passenger = []
    	@anonymous = []

    	@driver = Rating.where(user_id: user, :user_type => "driver")
    	@d5 = @driver.where(user_id: user,:star => "5").count
    	@d4 = @driver.where(user_id: user,:star => "4").count
   		@d2 = @driver.where(user_id: user,:star => "2").count
    	@d3 = @driver.where(user_id: user,:star => "3").count
    	@d1 = @driver.where(user_id: user,:star => "1").count

    	@passenger = Rating.where(user_id: user, :user_type => "passenger")
    	@p5 = @passenger.where(user_id: user,:star => "5").count
    	@p4 = @passenger.where(user_id: user,:star => "4").count
    	@p2 = @passenger.where(user_id: user,:star => "2").count
    	@p3 = @passenger.where(user_id: user,:star => "3").count
    	@p1 = @passenger.where(user_id: user,:star => "1").count

    	@anonymous = Rating.where(user_id: user, :user_type => "unknown")
    	@a5 = @anonymous.where(user_id: user,:star => "5").count
    	@a4 = @anonymous.where(user_id: user,:star => "4").count
    	@a2 = @anonymous.where(user_id: user,:star => "2").count
    	@a3 = @anonymous.where(user_id: user,:star => "3").count
    	@a1 = @anonymous.where(user_id: user,:star => "1").count	
	end

  def raise_not_found!
    response = "No route matches #{params[:unmatched_route]}"
    ::NewRelic::Agent.record_custom_event('RouteNotFound', error: response, rails_environment: Rails.env)
    flash[:alert] = response
    redirect_to root_path
  end

  #render 404 error 
  def render_not_found(e)
    response = "#{e}"
    ::NewRelic::Agent.record_custom_event('RecordNotFound', error: response, rails_environment: Rails.env)
    respond_to do |f| 
      f.html do
        flash[:alert] = response
        redirect_to root_path
      end
      f.js{ render error: response, status: 404 }
    end
  end

  #render unknown error
  def render_unknown_error(e)
    response = "#{e}"
    ::NewRelic::Agent.record_custom_event('UnknownError', error: response, rails_environment: Rails.env)
    flash[:alert] = response
    redirect_to root_path
  end

end
