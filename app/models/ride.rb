class Ride < ActiveRecord::Base

	# default_scope { where(archieve: 0) }

	has_many :routes, dependent: :destroy
	has_many :locations, dependent: :destroy
	has_many :message_threads, dependent: :destroy
	has_many :visitors, dependent: :destroy
	has_many :booking_notifications, dependent: :destroy
	has_many :bookings
	belongs_to :car
	belongs_to :user
	has_many :transfers, dependent: :destroy
	has_many :transections, dependent: :destroy
	has_many :ride_weeks, dependent: :destroy
	has_many :ride_months, dependent: :destroy
	validates :departure_date, presence: true
	validates :number_of_seats, presence: true
	validates :number_of_seats, :numericality => { only_integer: true }
	# validates :number_of_seats, inclusion: { in: 1..7, message: "Number of seats must be less than or equal to 7." }
	# validates :return_date, presence: true, :if => "is_round_trip.present?"
	validate :present_tos
	validate :present_car
	# validate :blow_departure_date

	attr_accessor :enable_locations_validation, :enable_routes_validation, :accept_tos,
	 :enable_ride_weeks_validation, :enable_ride_months_validation
	validates_associated :locations, :if => "enable_locations_validation.present?"
	accepts_nested_attributes_for :locations, allow_destroy: true

	validates_associated :routes, :if => "enable_routes_validation.present?"
	accepts_nested_attributes_for :routes

	validates_associated :ride_weeks#, :if => "enable_ride_weeks_validation.present?"
	accepts_nested_attributes_for :ride_weeks

	validates_associated :ride_months
	accepts_nested_attributes_for :ride_months

	def self.active_rides
		Ride.where('user_id IS NOT NULL AND  full_completed > 0 AND ( ( return_date > ? AND is_recurring_trip = ?) OR departure_date > ? AND archieve = 0)', Time.now, true, Time.now)
	end

	def blow_departure_date
		if (departure_date.to_i > return_date.to_i) && is_round_trip.present?
			errors.add(:return_date, "Please set your return date after the departure date.")
		end
	end

  def add_visitor(user_id)
  	if self.user_id != user_id
	  	visitor = self.visitors.find_by(user_id: user_id)
	  	if visitor
	  		visitor.class.increment_counter :no_of_views, visitor.id
	  	else
	  		self.visitors.create(user_id: user_id)
	  	end
		end
  end

  def views_count
  	self.visitors.pluck(:no_of_views).sum
  end

	def present_car
		if car_id.present? &&  car_id == 0
			errors.add(:car_id, "Please mention your car for this ride.")
		end
	end

	def present_tos
		if accept_tos.present? && accept_tos == "no"
			errors.add(:accept_tos, "You must certify holding a driving license and valid car insurance to be able to publish your ride offer.")
		end
	end

	def source_location
		self.locations.find_by(ride_type: GlobalConstants::Locations::RIDE_TYPES[:source])
	end

	def destination_location
		self.locations.find_by(ride_type: GlobalConstants::Locations::RIDE_TYPES[:destination])
	end

	def sub_locations
		self.locations.where(ride_type: GlobalConstants::Locations::RIDE_TYPES[:sub_route])
	end

	def set_routes(routes_attributes)
		if self.routing_required.present?
			self.locations.each do |l|
				l.destroy if l.address.blank?
			end

			self.routes.destroy_all
			locations = self.locations.reorder('sequence ASC')

			if locations.count > 1
				counter_last_val = locations.count - 2
				for i in 0..counter_last_val
					self.routes.create(source_id: locations[i].try(:id), destination_id: locations[i+1].try(:id), price: 1)
				end # end of for loop
				if self.is_round_trip == true
					self.routes.create(source_id: locations[0].try(:id), destination_id: locations[locations.count - 1].try(:id), price: 1)
				end	
				r_count = routes.count
				if routes_attributes.count == r_count
					routes_attributes.each_with_index do |key, index|
						routes[index].price = key[1]['price']
						routes[index].seats = key[1]['seats_count']
						if key[1]['arrival_time'].present?
							routes[index].arrival_time = key[1]['arrival_time']
						end
						routes[index].save!	
					end
				end
				locations.each_with_index do |loc, index|
					loc.update(sequence: index)
				end

				self.update!(routing_required: false)
			end # end of if of location count
		end
	end

	def get_current_points
		return self.points
	end

	def show_sorce_destination_route
		"#{self.source_location.get_route_name} → #{self.destination_location.get_route_name}"
	end

	def show_sorce_destination_route_short_name
		"#{self.source_location.get_route_name.partition(',').first} <span>to</span> #{self.destination_location.get_route_name.partition(',').first}".html_safe
	end	

	def show_destination_sorce_route
		"#{self.destination_location.get_route_name} → #{self.source_location.get_route_name}"
	end

	def handle_return_date_and_recurring_weeks
		if self.is_round_trip.blank? && self.return_date.present?
			self.update(return_date: nil)
		end
		if self.is_recurring_trip.blank?
			self.ride_weeks.update_all(sat: false, sun: false, mon: false, tue: false, wed: false, thu: false, fri: false)
		end
	end

	def calculate_total_price
		self.routes.map(&:price).sum
	end

	def send_nearby_users_msg
    profile_ids = Profile.near(self.locations.first.address, 50).map(&:id)
    profile_ids.delete(self.user.id)
    profile_ids.try(:each) do |p_id|
      data = Profile.find(p_id)
      if data.user.notifications.where(name: "ride_from_hometown").present?
        to = data.user.phone_no_with_ext
        if to
          send_message_to_nearby(self, to)
        end
      end
    end
	end
	
	def send_published_confirmation(root_path)
		# if self.user.notifications.where(name: "ride_offer_published").present?
		if self.present?
			if self.user.notifications.notification_status('ride_offer_published')
				mandrill = MandrillMailer.new
				mandrill.send_published_confirmation_mandrill(@ride,root_path)
			end
			# end
			if self.user.notifications.where(name: "ride_post").present?
				send_message_on_publish(self)
			end
		end
	end

  def send_message_to_nearby(ride, to)
  	
  	begin
	  	if self.user.allow_ride_post_sms?
	      client = Twilio::REST::Client.new GlobalConstants::TWILIO_ID, GlobalConstants::TWILIO_TOKEN
	      message = "Trip from  \n #{ride.source_location.get_route_name} to  #{ride.destination_location.get_route_name} has just been posted on Lamule. \n You can contact the person to book a seat.!"
	      client.account.messages.create(
	          body: message,
	          to: to,
	          from: GlobalConstants::FROM_NUMBER
	      )
	    end
  	rescue Exception => e  
		  puts e.message  
  	end
  end

	def send_message_on_publish(ride)
		if self.user.phone_no_with_ext
			if self.user.allow_ride_post_sms?
				client = Twilio::REST::Client.new GlobalConstants::TWILIO_ID, GlobalConstants::TWILIO_TOKEN
				message = "Your trip from  \n #{ride.source_location.get_route_name} to  #{ride.destination_location.get_route_name} has just been posted. \n Your passengers can now contact you to book a seat.!"
				client.account.messages.create(
						body: message,
						to: self.user.phone_no_with_ext,
						from: GlobalConstants::FROM_NUMBER
				)
			end
		end
	end

	def send_updated_confirmation
		if self.user.notifications.where(name: "ride_offer_updated").present?
			# UserMailer.ride_offer_confirmation(self).deliver
		end
	end

	def send_private_message( sender, receiver, message_body )
		message_threads_id = self.create_message(sender.id, receiver.id, message_body)
		
		if receiver.notifications.where(name: "receive_private_message").present?
			# UserMailer.ride_private_message(self, sender, receiver, message_body, message_threads_id[:receiving_message_thread_id]).deliver
		  if receiver.notifications.notification_status('receive_private_message')
		  	mandrill = MandrillMailer.new
		  	mandrill.ride_private_message(sender,receiver,message_threads_id[:receiving_message_thread_id])
			end
		end
		return message_threads_id[:sending_message_thread_id]
	end

	def create_message(sender_id, receiver_id, message_body)
		
		sending_message_thread = self.message_threads.find_or_create_by( user_id: sender_id, communicator_id: receiver_id )
		receiving_message_thread = self.message_threads.find_or_create_by( user_id: receiver_id, communicator_id: sender_id )
		sending_message_thread.update!(unread: true) if sending_message_thread.unread.blank?
		
		if receiving_message_thread.unread.blank? || receiving_message_thread.status == GlobalConstants::MessageThreads::STATUS[:archived]
			receiving_message_thread.update!(unread: true, status: GlobalConstants::MessageThreads::STATUS[:active])
		end
		sending_message_thread.messages.create!(body: message_body, message_type: GlobalConstants::Messages::TYPE[:sent])
		receiving_message_thread.messages.create!(body: message_body, message_type: GlobalConstants::Messages::TYPE[:received])
		return {sending_message_thread_id: sending_message_thread.id, receiving_message_thread_id: receiving_message_thread.id }
	end

	def send_ride_offer_sms( sender, receiver, message_body )
		if receiver.allow_ride_offer_sms?
			client = Twilio::REST::Client.new GlobalConstants::TWILIO_ID, GlobalConstants::TWILIO_TOKEN
			# message = "LaMule: A new passenger #{sender.display_first_last_name} has just sent you a message about your trip #{self.show_sorce_destination_route} at #{self.departure_date.strftime("%A %d %B %Y - %I:%M %p")}. To answer go to LaMule."
			message = "New message on Lamule! \n #{message_body}\n -- #{sender.display_first_last_name}.\n To answer go to Lamule."
			client.account.messages.create(
					body: message,
					to: user.phone_no_with_ext,
					from: GlobalConstants::FROM_NUMBER
			)
		end
	end
end