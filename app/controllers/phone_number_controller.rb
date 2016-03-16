class PhoneNumberController < ApplicationController

	before_action :load_phone_number, only: [:fill_phone, :verify_phone_number, :confirm_phone, :confirmation_phone]

	def fill_phone
		@selected_country = @phone_number.get_country
	end

	def verify_phone_number
		phone = fetch_phone_number_from_params
		@flag = true
		begin
			# generate a random code
			code = rand.to_s[3..6]
			@phone_number.update!(body: params[:phone_number], verification_code: code, country_id: params[:country_id])
			
			message = t('.send_message', code: code)
			# sending verification code on cell phone
			send_code_on_mobile phone, message
			
		rescue Exception => e
			puts "=== verify_phone_number === #{e}"
			@flag = false
		end
		verify_phone_number_response
	end

	def confirm_phone
		if @phone_number.verification_code == params[:code].to_i
			begin
				@phone_number.update!(verified_no: true)
				return render json: true
			rescue Exception => e
				puts "=== confirm_phone ==="
				puts e
				return render json: false;
			end
			return render json: true
		else
			return render json: false
		end
	end

	private
		def load_phone_number
			@phone_number = current_user.phone_number
		end

		def fetch_phone_number_from_params
			if params[:phone_number][0] == "0"
				params[:phone_number].slice!(0)
			end 
			if params[:country_code] != "0"
				phone = "#{params[:country_code]}#{params[:phone_number]}".gsub(/[^+0-9]/, "")
			else
				phone = "#{params[:phone_number]}".gsub(/[^+0-9]/, "")
			end
			phone
		end

		def send_code_on_mobile phone, message
			client = Twilio::REST::Client.new GlobalConstants::TWILIO_ID, GlobalConstants::TWILIO_TOKEN
			client.account.messages.create(
					body: message,
					to: phone,
					from: GlobalConstants::FROM_NUMBER
			)
		end

		def verify_phone_number_response
			if @flag
				respond_to do |format|
		    	format.json { render :json => {:success => true} }
				end
			else
				respond_to do |format|
					format.js {  flash.now[:notice] = 'This phone number is not valid' }
			    format.json { render :json => {:success => false}}
				end
			end
		end
end
