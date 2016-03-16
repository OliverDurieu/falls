class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		auth = request.env["omniauth.auth"]
		@user = User.find_for_facebook_oauth(auth)
		@graph = Koala::Facebook::API.new(auth.credentials.token)
		profile = @graph.get_object("me")
		friends = @graph.get_connections("me", "friends")
		cF = auth["extra"]["raw_info"]["friends"]["summary"]["total_count"]
		add_friends(friends, @user)
		countF(@user, cF)
		if session[:ride_id].present?
			set_ride_user
		elsif session[:fride_id].present?
			set_find_ride_user
		elsif session[:next_page].present?
			after_login_move_next_page
		elsif @user.persisted?
			sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
			set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
		else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
		if current_user 
			Analytics.alias(previous_id: session.id, user_id: @user.id)
			Analytics.identify(user_id: @user.id, traits: {email: @user.email, firstName: @user.first_name, lastName: @user.last_name, gender: @user.gender, createdAt: @user.created_at})
			Analytics.track(user_id: @user.id, event: current_user.sign_in_count == 1 ? "Signed up" : "Signed in")
			Analytics.track(user_id: @user.id, event: current_user.sign_in_count == 1 ? "Signed up with facebook" : "Signed in with facebook")
		end
	end


	private

	def add_friends(friends, user)
		begin
			friends.each do |friend|
				Friend.create(name: friend["name"], friend_id: friend["id"], user_id: user.id) unless @user.friends.find_by_friend_id(friend["id"])
			end
		rescue Exception => e
			puts e
		end
	end

	def countF(user, c)
		user.update_attribute(:total_count,c)
	end
	
end