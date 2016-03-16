class ProfileController < ApplicationController

	before_filter :load_profile, only: [:general, :photo, :address, :update_address]
	before_filter :load_phone_number, only: [:general]

	def update_general_info
		old_email = current_user.email
		old_phone_no = current_user.phone_no_with_ext

		if current_user.update(general_user_profile_params)
			if current_user.email != old_email
				current_user.update!(email_verified: false)
			end
			if current_user.phone_no_with_ext != old_phone_no
				current_user.phone_number.update!(verified_no: false)
			end
			redirect_to general_profile_index_path, notice: t('.succeed')
		else
			load_profile
			load_phone_number
			render 'general'
		end
	end

	def upload_photo
		@profile = Profile.find(params[:id])
		if @profile.update(profile_photo_params)
			redirect_to photo_profile_index_path, notice: t('.succeed')
		else
			render 'photo'
		end
	end

	def verifications
		@user = current_user
	end

	def update_address
		if @profile.update(profile_address_params)
			# redirect_to address_profile_index_path, notice: t('.succeed')
			redirect_to general_profile_index_path, notice: t('.succeed')
		else
			flash[:error] = @profile.errors.full_messages
			render 'address'
		end
	end

	def verify_email_phone
		email_verification_code = current_user.driver_verification.email_token
		mobile_verification_code = current_user.phone_number.verification_code
		puts params[:email_verification_number]
		puts params[:phone_verification_number]
		if email_verification_code == params[:email_verification_number].to_s && mobile_verification_code == params[:phone_verification_number].to_i
			current_user.update_columns(email_verified: true, verified_credentials: true)
			current_user.phone_number.update_column(:verified_no, true)
			flash[:notice] = "Information successfully verified!"
		else
			flash[:notice] = "Please provide the valid pin codes for verification."	
		end	
		redirect_to :back

	end	

	private
	def load_profile
		@user = current_user
		@profile = @user.profile
	end

	def load_phone_number
		@phone_number = @user.phone_number
		if @phone_number.present?
			@selected_country = @phone_number.get_country
		else
			@selected_country = ''
		end
	end

	def general_user_profile_params
		params.require(:user).permit(:gender,:first_name, :last_name, :email, :birth_year, :enable_profile_validation, :enable_phone_number_validation, profile_attributes: [:id, :displayed_as, :mini_bio], phone_number_attributes: [:id, :country_id, :body, :public_status])
	end

	def profile_photo_params
		params.require(:profile).permit(:photo, :check_photo)
	end

	def profile_address_params
		params.require(:profile).permit(:address_1, :address_2, :postcode, :city, :country, :longitude, :latitude)
	end
end
