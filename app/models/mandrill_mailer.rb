class MandrillMailer 

  include Rails.application.routes.url_helpers

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new
  end 

  def send_published_confirmation_mandrill(ride,root)
    if ride.user.notifications.where(name: "ride_offer_updated").present?
      template_name = "lamule-view-ride-sa"
      template_content = []
      message = {
        to:[{email: "#{ride.user.email}"}],
        subject: "Your trip from (#{ride.source_location.get_route_name}) to (#{ride.destination_location.get_route_name}) has been successfully posted on LaMule!",
        merge_vars: [{
          rcpt: ride.user.email,
          vars: [
            {name: "ALLRIDES", content: "#{BASE_URL}/rides"},
            {name: "NAME", content: ride.user.display_first_last_name},
            {name: "PHONE", content: ride.user.phone_number.body.present? ? ride.user.phone_number.body : "NA"}, 
            {name: "RIDEDEPARTUREDATE", content: ride.departure_date.strftime("%A %d %B %Y")},
            {name: "RIDEDEPARTURETIME", content: ride.departure_date.strftime("%I:%M %p")},
            {name: "RIDETOTALPRICE", content: "$#{ride.total_price} per passenger"},
            {name: "RIDENUMBEROFSEATS", content: "#{ride.number_of_seats} seats available"},
            {name: 'LAMULEBLOG', content: "thelamuleblog.com.au"},
            {name: 'CONTACT', content: "#{BASE_URL}/dashboard/contact_us"}
          ] 
        }
      ]
      }
      mandrill_client.messages.send_template template_name, template_content,message
    end 
  end

  def send_updated_ride_confirmation(ride,root)
    template_name = 'ride-offer-updation'
    template_content = []
    message = {
      to:[{email: "#{ride.user.email}"}],
        subject: "Your trip from (#{ride.source_location.get_route_name}) to (#{ride.destination_location.get_route_name}) has been edited successfully on LaMule!",
        merge_vars: [{
          rcpt: ride.user.email,
          vars: [
            {name: "RIDESOURCE", content: ride.source_location.get_route_name},
            {name: "RIDEDESTINITION", content: ride.destination_location.get_route_name},
            {name: "RIDEDEPARTURETIME", content: ride.departure_date.strftime("%A %d %B %Y - %I:%M %p")}, 
            {name: "RIDERETURNTIME", content: ride.return_date.present? ? ride.return_date.strftime("%A %d %B %Y - %I:%M %p"):"none"},
            {name: "RIDENUMBEROFSEATS", content: "#{ride.number_of_seats} seats available"},
            {name: "RIDETOTALPRICE", content: "$#{ride.total_price} per passenger"},
            {name: "BASE_URL", content: "#{BASE_URL}"},
            {name: "ROOT_PATH", content: root},
            {name: "USERNAME", content: ride.user.name},
            {name: "RIDE_PATH", content: root+"/rides/#{ride.id}"},
          ] 
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content,message
  end

  def contact_us_submit(first_name,last_name,email,message)
    template_name = "contact-us-submit" 
    template_content = []
    message = {
      to:  [{email: DEFAULT_RCPT_EMAIL}],
      subject: "contact us",
      merge_vars: [{
        rcpt: DEFAULT_RCPT_EMAIL,
        vars: [
          {name: "FIRSTNAME", content: first_name},
          {name: "LASTNAME", content: last_name},
          {name: "EMAIL", content: email},
          {name: "MESSAGE", content: message}
        ]
      }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def delete_account(reason, comment, user)
    template_name = "delete-account"
    template_content = []
    message = {
      to: [{email: DEFAULT_RCPT_EMAIL}],
      subject: "Delete Account",
      merge_vars: [{
        rcpt: DEFAULT_RCPT_EMAIL,
        vars: [
          {name: "USEREMAIL", content: user.email},
          {name: "REASON", content: reason},
          {name: "COMMENT", content: comment}

        ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def email_verification(user)
    template_name = 'email-verification'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: 'Account Verification',
      merge_vars: [{
        rcpt: user.email,
        vars: [
          {name: "USEREMAIL", content: user.email},
          {name: "VERIFYURL", content: "#{BASE_URL}/verified_the_email"}
        ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def email_alerts(user,ride)
    template_name = 'email-alerts'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: 'Testing',
      merge_vars: [{
        rcpt: user.email,
        vars: [
          {name: 'USERFIRSTNAME', content: user.first_name},
          {name: 'RIDESOURCE', content: ride.source_location.get_route_name},
          {name: 'RIDEDESTINITION', content: ride.destination_location.get_route_name},
          {name: 'RIDEDEPARTUREDATE', content: ride.departure_date},
          {name: 'RIDESEATS', content: ride.number_of_seats}


        ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def ride_private_message(sender, receiver,message_thread_id)
    template_name = 'email-message-sa-lamule'
    template_content = []
    message = {
      to: [{email: receiver.email}],
      subject: "You've received a private message from #{sender.display_first_last_name} on LaMule",
      merge_vars: [{
        rcpt: receiver.email,
        vars: [
          {name: 'NAME', content: sender.display_first_last_name},
          {name: 'MESSAGETHREADPATH', content: "#{BASE_URL}/message_threads/#{message_thread_id}"},
          {name: 'LAMULEBLOG', content: "thelamuleblog.com.au"},
          {name: 'CONTACT', content: "#{BASE_URL}/dashboard/contact_us"},

        ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def welcome_email(user)
    template_name = 'welcome-email-1'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "Welcome to The Falls",
      merge_vars: [{
        rcpt: user.email,
        vars: [
          {name: 'LAMULEBLOG', content: "thelamuleblog.com.au"},
          {name: 'PROFILEURL', content: "#{BASE_URL}/profile/general"},
          {name: 'CONTACT', content: "#{BASE_URL}/dashboard/contact_us"},
        ]
        }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def rating_recieved_mail(user)
    template_name = "rating-recieved-lamule"
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "You have received a new rating at LaMule",
      merge_vars: [{
        rcpt: user.email,
        vars: [
          {name: 'SUBJECT', content: 'You have received a new rating.'},
          {name: 'RATINGLINK', content: "#{BASE_URL}/ratings/received"}
        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def prompt_a_review_mail(user,reviewer)
    template_name = 'prompt-to-leave-a-rating-lamule'
    template_content = []
    message = {
      to: [{email: reviewer.email}],
      subject: "Would you like to leave a review for your recent journey?",
      merge_vars:[{
        rcpt: reviewer.email,
        vars: [
          {name: 'NAME', content: user.display_first_last_name},
          {name: 'RATEURL', content: "#{BASE_URL}/ratings/new?uid=#{user.id}"}
        ]
        }] 
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def ride_cancellation(user,ride,number_of_seats)
    template_name = 'passenger-cancel-trip-lamule'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "Your LaMule trip cancellation details.",
      merge_vars:[{
        rcpt: user.email,
        vars: [
          {name: 'BASEPATH', content: "#{BASE_URL}"},
          {name: 'NAME', content: user.display_first_last_name},
          {name: 'ADDRESS', content: user.profile.address_1.present? ?  user.profile.address_1 : "No address provided"},
          {name: 'PROFILELINK', content: "#{BASE_URL}/profile/address"}, 
          {name: 'PHONENUMBER', content: user.phone_number.body.present? ? user.phone_number.body : "No phone number provided"},
          {name: 'DRIVERNAME', content: ride.user.display_first_last_name},
          {name: 'DRIVERPHONE', content: ride.user.phone_number.body.present? ? ride.user.phone_number.body : "No phone number provided"},
          {name: 'DEPARTURETIME', content: ride.departure_date.strftime("%B %d, %Y at %I:%M%p")},
          {name: 'DEPARTURELOCATION', content: ride.locations.where(ride_type: 'source').pluck(:address).first},
          {name: 'TRIPCOST', content: ride.total_price * number_of_seats},
          {name: 'CARDNUMBER', content: "42424242424242424242424242"},
          
          # {name: 'ADDRESS', content: user} to be filled
          # {name: 'PHONENUMBER', content: user.first_name},
        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def booking_details(user,ride, qty)
    template_name = 'seat-booked-lamule'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "Your LaMule booking details.",
      merge_vars:[{
        rcpt: user.email,
        vars: [
          {name: 'NAME', content: user.display_first_last_name},
          {name: 'ADDRESS', content: user.profile.address_1.present? ?  user.profile.address_1 : "No address provided"},
          {name: 'PROFILELINK', content: "#{BASE_URL}/profile/address"}, 
          {name: 'PHONENUMBER', content: user.phone_number.body.present? ? user.phone_number.body : "No phone number provided"},
          {name: 'DRIVERNAME', content: ride.user.display_first_last_name},
          {name: 'DRIVERPHONE', content: ride.user.phone_number.body.present? ? ride.user.phone_number.body : "No phone number provided"},
          {name: 'DEPARTURETIME', content: ride.departure_date.strftime("%B %d, %Y at %I:%M%p")},
          {name: 'DEPARTURELOCATION', content: ride.locations.where(ride_type: 'source').pluck(:address).first},
          {name: 'TRIPCOST', content: ride.total_price * qty},
          {name: 'TRANSACTIONFEE', content: ride.total_price},
          {name: 'CARBONOFFSET', content: ""},
          {name: 'TOTAL', content: ride.total_price},
          {name: 'CO2SAVED', content: (ride.total_distance.to_i * 0.3).round(2)}


        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end 

  def driver_booking_notification ride,booking
    template_name = 'driver-booking-notification'
    template_content = []
    message = {
      to: [{email: ride.user.email}],
      subject: "Your ride's booking details.",
      merge_vars:[{
        rcpt: ride.user.email,
        vars: [
          {name: 'SOURCE', content: ride.source_location.get_route_name},
          {name: 'DESTINITION', content: ride.destination_location.get_route_name},
          {name: 'DEPARTUREDATE', content: ride.departure_date.strftime("%B %d, %Y at %I:%M%p")}, 
          {name: 'DEPARTURELOCATION', content: ride.source_location.get_route_name},
          {name: 'DRIVERNAME', content: ride.user.display_first_last_name},
          {name: 'PHONE', content: ride.user.phone_number.body.present? ? ride.user.phone_number.body : "No phone number provided"},
          {name: 'COST', content: "$ #{booking.no_of_seats_booked * ride.total_price}"},
          {name: 'YOURPROFILE', content: "#{BASE_URL}/profile/general"},
          {name: 'LAMULEBLOG', content: "thelamuleblog.com.au"},
          {name: 'CONTACTUS', content: "#{BASE_URL}/dashboard/contact_us"},
          {name: 'SEATS', content: booking.no_of_seats_booked},
          {name: 'CUSTOMERPROFILE', content: "#{BASE_URL}/users/#{booking.user.id}/public_profile"},
          {name: 'CUSTOMERNAME', content: booking.user.display_first_name}

        ]
        }]
    }
    res = mandrill_client.messages.send_template template_name, template_content, message
  end  

  def driver_ride_cancellation(user,ride)
    template_name = 'driver-cancel-trip-lamule'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "Your LaMule trip cancellation details.",
      merge_vars:[{
        rcpt: user.email,
        vars: [
          {name: 'BASEPATH', content: "#{BASE_URL}"},
          {name: 'NAME', content: user.display_first_last_name},
          {name: 'ADDRESS', content: user.profile.address_1.present? ?  user.profile.address_1 : "No address provided"},
          {name: 'PROFILELINK', content: "#{BASE_URL}/profile/address"}, 
          {name: 'PHONENUMBER', content: user.phone_number.body.present? ? user.phone_number.body : "No phone number provided"},
          {name: 'DRIVERNAME', content: user.display_first_last_name},
          {name: 'DRIVERPHONE', content: user.phone_number.body.present? ? user.phone_number.body : "No phone number provided"},
          {name: 'DEPARTURETIME', content: ride.departure_date.strftime("%B %d, %Y at %I:%M%p")},
          {name: 'DEPARTURELOCATION', content: ride.locations.where(ride_type: 'source').pluck(:address).first}          
        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end  

  def password_changed_successfully(user)
    template_name = 'lamule-password-changed'
    template_content = []
    message = {
      to: [{email: user.email}],
      subject: "Successfully changed password.",
      merge_vars:[{
        rcpt: user.email,
        vars: [
          {name: 'PROFILEPATH',content:"#{BASE_URL}/profile/general"},
          {name: 'POSTRIDEPATH',content: "#{BASE_URL}/offer-seats/1"} 
        ]
        }]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end 

  def driver_verification(code, email,first_name)
    template_name = "driver-email-verification" 
    template_content = []
    message = {
      to:  [{email: email}],
      subject: "Verification Pin",
      merge_vars: [{
        rcpt: email,
        vars: [
          {name: "USEREMAIL", content: first_name},
          {name: "EMAILCODE", content: code}
        ]
      }
      ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end 

end
