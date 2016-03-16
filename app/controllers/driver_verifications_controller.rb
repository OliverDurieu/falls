class DriverVerificationsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_header
	before_action :set_mobile_header_flag, :only => [:finished,:steps]
	before_action :set_message_icon_flag, :only => [:finished,:steps]
	before_action :set_duplicate_email_flag, :only => [:email_token_generator]
	before_action :activate_wizard_nav, except: [:index]

	layout 'driver_verification', except: [:index]

	def index
	end
	
	def set_mobile_header_flag
		@mobile_header_flage = true
	end

	def steps
		@verify = DriverVerification.new
		@verify.f_name = current_user.first_name
		@verify.l_name = current_user.last_name
		@verify.email = current_user.email
		if current_user.cars.present?
			@verify.car_make = current_user.cars.first.car_maker.id
			@verify.car_image = current_user.cars.first.car_image
			@verify.car_model = current_user.cars.first.car_maker.car_models.first.name 
			@car = current_user.cars.first
		else	
			@verify.car_make = CarMaker.first.id
			@verify.car_image = 'upload_img.png'
			@verify.car_model = CarMaker.first.car_models.first.name
			@car = current_user.cars.create
			@car.car_maker_id = CarMaker.first.id
			@car.save
		end
		if current_user.profile.present?
			@verify.post_code = current_user.profile.postcode
			@verify.post_address = current_user.profile.address_1
			@verify.avatar = current_user.profile.picture
		else	
			@verify.avatar = 'user/icon-man-72.png'
			@verify.post_code = nil
			@verify.post_address = nil
		end	
   		@final_step = current_user.driver_verification.verified if current_user.driver_verification.present?
	end	

	def finished

	end

	def profile
		@verify = DriverVerification.new
		@user = current_user
	end

	def personal
		@user = current_user
		@car = current_user.cars.first
	end	

	def verify_personal_info
		if params[:pin_email] != "" && params[:pin_mobile] != ""
			if current_user.driver_verification.email_token == params[:driver_verification][:pin_email] || current_user.verified_credentials
				current_user.phone_number.update!(verified_no: true)
				current_user.update!(email_verified: true, verified_credentials: true)
				current_user.update(email: params[:driver_verification][:update_email]) 
				current_user.cars.first.update_car_info(params[:driver_verification][:car_model], params[:driver_verification][:car_make], params[:driver_verification][:car_image].present? ? params[:driver_verification][:car_image] : nil) if current_user.cars.present?
				current_user.profile.update_verification_information(params[:driver_verification][:post_code],params[:driver_verification][:post_address], params[:driver_verification][:avatar].present? ? params[:driver_verification][:avatar] :nil ) if current_user.profile.present?
				current_user.driver_verification.update_attributes(verified: true)
				redirect_to finished_driver_verifications_path
			else
				redirect_to steps_driver_verifications_path
			end	
		else
			redirect_to steps_driver_verifications_path
		end
	end	

	def email_token_generator	
	 	email = params[:email]
		driver_ver = current_user.driver_verification
		if @duplicate_email_flag == false
			token = CodeGenerator::Generator.generate(uniqueness: { model: :driver_verification, field: :email_token })
			driver_ver.email_token = token
			if driver_ver.save
				send_verification_email(token, email, current_user.first_name)
				respond_to do |format|
				format.json { render :json => { success: true },:flash => {:notice => 'An email has been sent with the verification pin.' }}
				format.html {redirect_to :back, :flash => {:notice => 'An email has been sent with the verification pin.' }}
				end 
			end			
		else
			respond_to do |format|
				format.js {  flash.now[:notice] = 'This email is already connected to another user' }
				format.json { render :json => { :success => false }}
			end	
		end
	end 
	
	def set_duplicate_email_flag
		email = params[:email]
		@duplicate_email_flag = false
		if current_user.email == email
			@duplicate_email_flag = false
		else
			@duplicate_email_flag = User.where(email: email).present?
		end
	end

	def verify_email_pin_code
		 if current_user.driver_verification.email_token == params[:email_pin]
			respond_to do |format|
				format.json { render :json => {:success => true}}
			end
		else
			respond_to do |format|
			format.js {  flash.now[:notice] = "Wrong PinCode" }
	    	format.json { render :json => {:success => false}}
			end
		end
	end
	
	def verify_phone_pin_code
		if current_user.phone_number.verification_code.to_s == params[:phone_pin]
			respond_to do |format|
				format.json { render :json => {:success => true}}
			end
		else
			respond_to do |format|
				format.js {  flash.now[:notice] = "Wrong PinCode" }
	    	format.json { render :json => {:success => false}}
			end
		end
	end

	def check_email_verified
		if current_user.email_verified == true
			respond_to do |format|
			format.json { render :json => {:success => true}}
			end
		else
			respond_to do |format|
			format.json { render :json => {:success => false}}
			end
		end
	end


	def check_phone_verified
		if current_user.phone_number.verified_no == true
			respond_to do |format|
			format.json { render :json => {:success => true}}
			end
		else
			respond_to do |format|
			format.json { render :json => {:success => false}}
			end
		end
	end

	private
		def send_verification_email(code, email, first_name)
		 mail_obj = MandrillMailer.new
		 mail_obj.driver_verification(code, email, first_name)
		end

		def verification_params
			params.require(:driver_verification).permit!
		end

		def activate_wizard_nav
			@wizard_nav = true
		end
end
