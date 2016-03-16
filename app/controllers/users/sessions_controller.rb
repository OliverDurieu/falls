class Users::SessionsController < Devise::SessionsController
	prepend_before_filter :require_no_authentication, only: [:new]
	prepend_before_filter :allow_params_authentication!, only: :create
	# prepend_before_filter only : [:create] { request.env["devise.skip_timeout"] = true }

	# GET /resource/sign_in
	def new
		self.resource = resource_class.new(sign_in_params)
		clean_up_passwords(resource)
		if params[:layout_false].present?
			return render layout: false
		elsif params[:next_page].present?
			session[:next_page] = params[:next_page]
			respond_with(resource, serialize_options(resource))
		else
			respond_with(resource, serialize_options(resource))
		end
	end

	# POST /resource/sign_in
	def create
		@user = resource_class.find_by(email: params[resource_name][:email]) || nil
		if session[:ride_id].present?
			set_ride_user
		elsif session[:fride_id].present?
			set_find_ride_user
		elsif session[:next_page].present?
			after_login_move_next_page
		elsif @user and @user.encrypted_password.present?
			super
		elsif @user.try(:provider) == 'facebook'
			redirect_to user_omniauth_authorize_path(:facebook)
		else
			redirect_to new_user_session_path, alert: "Incorrect email/password combination"
		end
		if current_user 
			Analytics.identify(user_id: @user.id, traits: {email: @user.email, firstName: @user.first_name, lastName: @user.last_name, gender: @user.gender, createdAt: @user.created_at})
			Analytics.track(user_id: @user.id, event: "Signed in")
		end
	end

	# DELETE /resource/sign_out
	def destroy
		super
	end
end
