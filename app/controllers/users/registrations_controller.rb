class Users::RegistrationsController < Devise::RegistrationsController
	layout "profile", only: [:edit, :update]
	prepend_before_filter :require_no_authentication, only: [:create]

	def new
		if params[:rid].present? && Ride.find_by(id: params[:rid], user_id: nil).present?
			session[:ride_id] = params[:rid]
		elsif params[:frid].present? && Ride.find(params[:frid]).present?
			session[:fride_id] = params[:frid]
		end
		super
		Analytics.track(user_id: session.id, event: "Starts signing up")
	end

	# POST /resource
	def create
		build_resource(sign_up_params)
		resource_saved = resource.save
		yield resource if block_given?
		if resource_saved
			resource.profile.update_attribute(:postcode, params[:user][:profile][:postcode])
			resource.phone_number.update_attribute(:body, params[:user][:phone_number][:body])
			mailchimp(resource.email) if resource.receive_updates?
			if resource.active_for_authentication?
				set_flash_message :notice, :signed_up if is_flashing_format?
				sign_up(resource_name, resource)
				if session[:ride_id].present?
					ride = Ride.find(session[:ride_id]) rescue nil
					session.delete(:ride_id)
					if ride.present?
						ride.update!(user_id: resource.id)
						respond_with resource, location: after_sign_up_path_for(resource, ride, "new_ride")
					else
						respond_with resource, location: after_sign_up_path_for(resource)
					end
				elsif  session[:fride_id].present?
					ride = Ride.find(session[:fride_id])
					if ride.present?
						respond_with resource, location: after_sign_up_path_for(resource, ride, "find_ride")
					else
						session.delete(:fride_id)
						respond_with resource, location: after_sign_up_path_for(resource)
					end
				else
					respond_with resource, location: after_sign_up_path_for(resource)
				end
			else
				set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
				expire_data_after_sign_in!
				respond_with resource, location: after_inactive_sign_up_path_for(resource)
			end
			Analytics.alias(previous_id: session.id, user_id: current_user.id)
			Analytics.identify(user_id: current_user.id, traits: {email: current_user.email, firstName: current_user.first_name, lastName: current_user.last_name, gender: current_user.gender, createdAt: current_user.created_at})
			Analytics.track(user_id: current_user.id, event: "Signed up")
		else
			clean_up_passwords resource
			respond_with resource
		end
		
	end

	def update
		self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
		prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

		resource_updated = update_resource(resource, account_update_params)
		yield resource if block_given?
		if resource_updated
			if is_flashing_format?
				flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
						:update_needs_confirmation : :updated
				mandrill = MandrillMailer.new
				mandrill.password_changed_successfully(current_user)			
				set_flash_message :notice, flash_key
			end
			sign_in resource_name, resource, bypass: true
			respond_with resource, location: after_update_path_for(resource)
		else
			clean_up_passwords resource
			respond_with resource
		end

	end

	# DELETE /resource
	def destroy
		begin
			reason = UnsubscribeReason.find_by_id(params[:account_delete_reason]).present? ? UnsubscribeReason.find(params[:account_delete_reason]).name : "N/A"
			# UserMailer.delete_account(reason, params[:unsubscribe_comment], current_user).deliver
			mandrill_mailer = MandrillMailer.new
			mandrill_mailer.delete_account(reason, params[:unsubscribe_comment], current_user)
			current_user.destroy
			return redirect_to root_path, notice: "Account is successfully deleted"
		rescue Exception => e
			flash[:danger] = "Unable to delete account. An External Error occure Please try again later"
			return redirect_to account_users_path
		end
		resource.destroy
		Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
		set_flash_message :notice, :destroyed if is_flashing_format?
		yield resource if block_given?
		respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
	end

	private
	def after_sign_up_path_for(resource, ride=nil, type=nil)
		if ride.present?
			if type == "new_ride"
				ride.send_published_confirmation(root_path)
				flash[:notice] = t('rides.published', ride_id: ride.id)
				publication_ride_path(ride.id)
			elsif type == "find_ride"
				flash[:notice] = "Thanks for joining The Falls. One more step and we will be all set"
				fill_phone_path
			end
				
				
		elsif resource.provider.blank?
			flash[:notice] = "Thanks for joining The Falls. One more step and we will be all set"
			fill_phone_path
		else
			after_sign_in_path_for(resource)
		end
	end

	def update_resource(resource, params)
		if resource.encrypted_password.present?
			resource.update_with_password(params)
		else
      		resource.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
		end
	end

	def mailchimp(email)

		# Gibbon::API.api_key = Global_Constants::MAILCHIMP_APIKEY
		Gibbon::API.api_key ='4f05a246c6ad74b922e84e54bdf5d03a-us8'
		Gibbon::API.timeout = 15
		Gibbon::API.throws_exceptions = true

		begin
			flag = Gibbon::API.lists.subscribe({ :apikey => '4f05a246c6ad74b922e84e54bdf5d03a-us8', :id => '0009f801bd',
																					 email: { email: email },
																					 merge_vars: {},
																					 double_optin: false,
																					 update_existing: true,
																					 replace_interests: true,
																					 send_welcome: true
																				 })
			flash[:notice] = "Thank you for susbscribing to our Newsletter."
			rescue => ex
			flash[:notice] = ex.to_s
		end

	end
end
