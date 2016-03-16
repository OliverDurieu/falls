class UserMailer < ActionMailer::Base
	default :from => "\"The Falls\" <zaeem@chimpchamp.com>"

	def delete_account(reason, comment, user)
		@reason = reason
		@comment = comment
		@user = user
		mail(to: "zaeem.asif@gmail.com", subject: t('.subject'))
	end

	def email_verification(user)
		@user = user
		mail(to: user.email, subject: t('.subject'))
	end

	def ride_offer_confirmation(ride)
		@user = ride.user
		@ride = ride
		@ride_source = @ride.source_location.get_route_name
		@ride_destination = @ride.destination_location.get_route_name
		subj = t('.subject', origin: @ride_source, destination: @ride_destination)
		mail(to: @user.email, subject: subj)
	end

	def ride_private_message( ride, sender, receiver, message_body, message_thread_id )
		@receiver = receiver
		@ride = ride
		@ride_source = @ride.source_location.get_route_name
		@ride_destination = @ride.destination_location.get_route_name
		@sender = sender
		@message = message_body
		@message_thread_id = message_thread_id
		@sender_name = @sender.display_first_last_name
		subj = t('.subject', sender_name: @sender_name)
		mail(to: @receiver.email, subject: subj)

	end

	def email_alerts(user, ride)
		to = user.email
		@user = user
		@ride = ride
		@ride_source = @ride.source_location.get_route_name
		@ride_destination = @ride.destination_location.get_route_name
		subj = t('.subject')
		mail(to: to, subject: subj)
	end

	def contact_us_submit(firstname="", lastname="", email="", message="")
	    @fname = firstname
	    @lname = lastname
	    @email = email
	    @message = message
	    

	    mail( :to => GlobalConstants::ADMIN_EMAIL , :subject => 'contact us')
  	end
end	