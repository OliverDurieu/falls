class DashboardController < ApplicationController
	before_action :set_message_icon_flag, :only => [:index]
	layout "dashboard", only: [:index]
	def show_dashboard
		@unread_received_message_threads_count =  current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? AND messages.message_type = ?", GlobalConstants::MessageThreads::STATUS[:active], true, GlobalConstants::Messages::TYPE[:received]).count rescue ""
		@unread_received_message_thread =  current_user.message_threads.joins(:messages).distinct.where("message_threads.status = ? AND message_threads.unread = ? ", GlobalConstants::MessageThreads::STATUS[:active], true)
		@unread_notifications = current_user.booking_notifications.not_seen.count
		@bookings = current_user.booking_notifications.not_seen
		render layout: 'application'
	end
	
	def index
		# force session to load in order to use session.id for analytics
		session.delete 'init'
		Analytics.track(user_id: current_user ? current_user.id : session.id, event: "Visited site")
	end

	def contact_us
	end
	def contact_us_submit
		firstname = params[:first_name]
		lastname = params[:last_name]
		email = params[:email]
		message = params[:message]
		# UserMailer.contact_us_submit(firstname,lastname,email,message).deliver
		mandrill_mailer = MandrillMailer.new
		mandrill_mailer.contact_us_submit(firstname,lastname,email,message)
		redirect_to root_path
	end

	def public_urls
		redirect_to root_path
	end

	# def resource_name
	# 	:user
	# end

	# def resource
	# 	@resource ||= User.new
	# end

	# def devise_mapping
	# 	@devise_mapping ||= Devise.mappings[:user]
	# end

end
