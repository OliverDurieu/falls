class UsersController < ApplicationController
	layout "profile", only: [:social_sharing, :credit_card, :update_credit_card_info,
							 :payments_history]
	before_filter :load_public_profile, only: [:public_profile]

	def complete_registration_proccess
		if session[:fride_id].present?
			ride_id = session[:fride_id]
			session.delete(:fride_id)
    	redirect_to contact_to_the_driver_ride_path(ride_id)
    else
			flash[:warning] = t('.welcome_message')
			return redirect_to dashboard_show_dashboard_path
    end
	end
	
	def signUp_email_page

	end
	
	def send_verify_email
		begin
      mandrill = MandrillMailer.new
      mandrill.email_verification(current_user)
			# UserMailer.email_verification(current_user).deliver
			redirect_to verifications_profile_index_path, notice: t('.succeed')
		rescue Exception => e
			puts "=== send_verify_email ==="
			puts e
			flash[:danger] = e
			redirect_to verifications_profile_index_path
		end
	end

	def verified_the_email
		if current_user.update(email_verified: true)
			redirect_to verifications_profile_index_path, notice: t('.succeed')
		else
			flash[:danger] = t('.failed')
			redirect_to verifications_profile_index_path
		end
	end

	def disconnect_facebook
		if current_user.update(provider: nil, uid: nil)
			current_user.friends.destroy_all
		end
		redirect_to :back
	end

	def public_profile
		@self_user = current_user && current_user.id == @user.id ? true : false
		show_ratings(@user)
	end
	
	def index
		if current_user.admin? 
			@users = User.all
		else
			redirect_to :back, notice: "Access denied."
		end
	end

	def index_facebook
		if current_user.admin? 
			@users = User.where("provider = ?", "facebook")
		else
			redirect_to :back, notice: "Access denied."
		end
	end

	def index_not_facebook
		if current_user.admin? 
			@users = User.where({provider: nil})
		else
			redirect_to :back, notice: "Access denied."
		end
	end		

	def show
  	@user = User.find(params[:id])
  	unless current_user.admin?
      	redirect_to :back, :alert => "Access denied."
    	end
  end

  def credit_card
    # call to stripe to gain access_token in order to perform Strip API operations
    if params[:code].present?  
      response = RestClient.post 'https://connect.stripe.com/oauth/token', :client_secret => 'sk_test_YWV7flMmdZVvQbHCmXKdPKvg', :code => params[:code], :grant_type => 'authorization_code'
      stripe_params = JSON.parse response.to_s
      current_user.update_columns(stripe_id: stripe_params['stripe_user_id'])
    end
  end

  def payments_history 
    @payments = current_user.transfer_requests
    @paid = current_user.transections.where(paid: true)
  end  

  def update_credit_card_info
    current_user.update_attribute(:credit_status,params[:user][:credit_status])
    redirect_to :back, :notice => "updated."
  end

	def update
  	@user = User.find(params[:id])
  	unless current_user.admin?
    		redirect_to :back, :alert => "Access denied."
  	end
  	if @user.update_attributes(secure_params)
    		redirect_to users_path, :notice => "User updated."
  	else
    		redirect_to users_path, :alert => "Unable to update user."
  	end
	end

	def destroy
  	user = User.find(params[:id])
  	unless current_user.admin?
    		redirect_to :back, :alert => "Access denied."
  	end
  	user.destroy
  	redirect_to users_path, :notice => "User deleted."
	end

	def verify_uid

		@user = current_user
		@fb_uid = params[:fb_id]
		flag = @user.verify_uid(current_user, @fb_uid)

		respond_to do |format|
	    format.json { render :json => {:success => flag} }
	    format.html { }
	  end
		# render json:@user
	end

  def send_direct_message
    
    reciever = User.find(params[:reciever])
    thread_id = current_user.send_private_message(current_user, reciever, params[:private_msg])
    redirect_to message_thread_path(thread_id)

  end



	
	private
	def load_public_profile
		@user = User.find(params[:id])
		@profile = @user.profile
	end

	def secure_params
  	params.require(:user).permit(:role)
	end



end