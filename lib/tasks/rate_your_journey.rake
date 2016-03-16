task :send_review_mail => :environment do
  Ride.where("departure_date < ?", Time.now).where(review_mail_sent_to: false).each do|ride|   
    puts "++++++++ TOTAL RIDES FETCHED: ++++++++"
    puts Ride.where("departure_date < ?", Time.now).where(review_mail_sent_to: false).size
    if ride.bookings.present?
     ride.bookings.each do|booking|
      if booking.user.notifications.notification_status('rate_the_passengers')
        mandrill = MandrillMailer.new
        mandrill.prompt_a_review_mail(ride.user,booking.user)
        puts "++++++++ NO BOOKINGS SO FAR ++++++++"
        ride.update_column(:review_mail_sent_to, true)
      else
        ride.update_column(:review_mail_sent_to, true)
        puts "++++++++ BY PASSED ++++++++"  
      end
     end 
    else
     puts "++++++++ NO BOOKINGS SO FAR ++++++++" 
     puts "++++++++ NO BOOKINGS SO FAR ++++++++" 
     puts "++++++++ NO BOOKINGS SO FAR ++++++++" 
     puts "++++++++ NO BOOKINGS SO FAR ++++++++" 
    end
  end  
end