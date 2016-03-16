module TwilioMethods
  def send_general_message_sms sender, receiver, message_body 
    if receiver.allow_ride_offer_sms?
      client = Twilio::REST::Client.new GlobalConstants::TWILIO_ID, GlobalConstants::TWILIO_TOKEN
      # message = "LaMule: A new passenger #{sender.display_first_last_name} has just sent you a message about your trip #{self.show_sorce_destination_route} at #{self.departure_date.strftime("%A %d %B %Y - %I:%M %p")}. To answer go to LaMule."
      message = "New message on Lamule! \n #{message_body}\n -- #{sender.display_first_last_name}.\n To answer go to Lamule."
      client.account.messages.create(
          body: message,
          to: receiver.phone_no_with_ext,
          from: GlobalConstants::FROM_NUMBER
      )
    end
  end
end  