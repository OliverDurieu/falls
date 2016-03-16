class User < ActiveRecord::Base
	enum role: [:user, :vip, :admin]
	after_initialize :set_default_role, :if => :new_record?

	has_one :driver_verification, dependent: :destroy
	has_one :phone_number, dependent: :destroy
	has_one :profile, dependent: :destroy
	has_one :preference, dependent: :destroy
	has_many :notifications, dependent: :destroy
	has_many :rides, dependent: :destroy
	has_one :unsubscribe
	has_many :cars, dependent: :destroy
	has_many :email_alerts, dependent: :destroy
	has_many :friends, dependent: :destroy
	has_many :bookings
	has_many :booking_notifications, dependent: :destroy
	has_many :transections, dependent: :destroy
	has_many :message_threads, dependent: :destroy
	has_many :receiving_message_threads, class_name: :MessageThread, foreign_key: "communicator_id"
	has_many :ratings, dependent: :destroy
	has_many :given_ratings, class_name: :Rating, foreign_key: :from_user_id
	has_many :visitors, dependent: :destroy
	has_many :transfer_requests
	has_many :transfer_transactions
	#validates :gender, presence: true, on: :create
	validates :first_name, presence: true, on: :create
	#validates :last_name, presence: true, on: :create
	#validates :birth_year, presence: true, on: :create

	validates_associated :profile, :if => "enable_profile_validation.present?"
	accepts_nested_attributes_for :profile

	validates_associated :phone_number, :if => "enable_phone_number_validation.present?"
	accepts_nested_attributes_for :phone_number

	validates_associated :notifications, :if => "enable_notifications_validation.present?"
	accepts_nested_attributes_for :notifications

	attr_accessor :enable_profile_validation, :enable_phone_number_validation, :enable_notifications_validation, :ride_id
	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable,
				 :omniauthable, omniauth_providers: [:facebook]


	after_create :create_supporting_objects
	before_create :create_profile
	after_create :send_welcome_mail
	after_create :build_driver_verification

	def calculated_rating
		if self.ratings.count == 0
			return "N/A"
		else	
			return (ratings.pluck('star').sum.to_f / ratings.count).round(2) 
		end
	end

	def send_welcome_mail
		mailer = MandrillMailer.new
		mailer.welcome_email(self)
	end	

	def set_default_role
		self.role ||= :user
	end

  def mc_subscribe
  	gb = Gibbon::API.new("85d24e69266f47b3f3d94ac6aa62711a-us9")
  	  # gb.list_subscribe({:id => "2a605f6938",
  	  #  :email_address => "zaeem.asif@gmail.com", :double_optin => false, :update_existing => true,
  	  #  :replace_interests =>false , :send_welcome => false,
  	  #  :merge_vars => { 'GROUPINGS' => {0  })
  	  gb.lists.subscribe({:id => '2a605f6938', :email => {:email => 'zaeem.asif@gmail.com'}, :merge_vars => {:FNAME => 'First Name', :LNAME => 'Last Name'}, :double_optin => false})
  end


	def create_supporting_objects
		self.create_phone_number #= PhoneNumber.find_by(user_id: self.id)
		self.create_preference
		DefaultNotification.all.each do |dn|
			self.notifications.create(name: dn.name, text: dn.text, medium: dn.medium)
		end
	end

	def display_first_name
		self.first_name.titleize
	end

	def display_first_last_name
		# "#{self.first_name.titleize} #{self.last_name[0].titleize}"
		"#{self.first_name.titleize}"
	end

	def age
		"#{Date.today.year - self.birth_year} years old" rescue ""
	end

	def phone_no_with_ext(separator="")
		if self.phone_number.try(:body).present?
			"#{self.phone_number.try(:country).try(:country_code) }#{separator}#{self.phone_number.try(:body)}"
		else
			""
		end
	end

	def get_fb_friends_count
		return self.friends.count
	end	

	def fb_connect?
		self.uid.present? && self.provider == "facebook"
	end

	def allow_ride_offer_sms?
	  self.phone_number.try(:body).present? && self.notifications.where(name: "ride_offer").present?
  end

  def allow_ride_post_sms?
	  self.phone_number.try(:body).present? && self.notifications.where(name: "ride_post", status: true).present?
  end

  def allow_ride_from_hometown?
	  self.phone_number.try(:body).present? && self.notifications.where(name: "ride_from_hometown", status: true).present?
  end

  def get_total_seats_booked
  	total_seats_booked = 0;
  	self.rides.each do |ride|
  		ride.bookings.each do |booking|
	  		if booking.no_of_seats_booked.present?
	  			total_seats_booked = booking.no_of_seats_booked + total_seats_booked
	  		end
  		end
  	end	
  	return total_seats_booked;
  end	

  def rides_gained_count
  	return self.bookings.select(:ride_id).uniq.count
  end	

  

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
				user.email = data["email"] if user.email.blank?
			end
		end
	end
	def self.find_for_facebook_oauth(auth)

		user = User.where(auth.slice(:provider, :uid)).first
		return user if user.present?
		user = User.find_by(email: auth.info.email)
		if user.present?
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			
			puts user.profile.photo
			user.gender = auth.extra.raw_info.gender
			user.save(validate: false)
			return user
		end

		user = User.new(
				provider: auth.provider,
				uid: auth.uid,
				email: auth.info.email,
				name: auth.info.name,
				first_name: auth.info.first_name,
				last_name: auth.info.last_name,
				# image: auth.info.image,
				gender: auth.extra.raw_info.gender
		)
		user.save(validate: false)
		user.profile.remote_photo = auth.info.image
		user.profile.save
		return user
	end
	def self.upload_profile_photo_facebook_oauth(auth)
		user = User.find_by(email: auth.info.email)
		pr = user.profile
		pr.photo = open(auth[:info][:image]) || nil
		pr.save
	end
  
	def verified_driver?
		user = self
		return user.driver_verification.verified if user.driver_verification.present?
		false
	end

	def facebook_linked?
		self.uid.present? && self.provider == 'facebook'
	end

	def verify_uid(user, fb_uid)
		u = User.where(uid:fb_uid).take
		if !u.present?		
			user.uid = fb_uid 
			user.provider = "facebook"
			user.save
			return true
		else
			if u == user
				return true			
			else
				return false
			end
		end
	end

	def generate_booking(ride, seats)
		user = self
    user.bookings.create(no_of_seats_booked: seats,
                         booking_date: Time.now, ride_id: ride.id,
                         status: 'waiting', token: Booking.generate_booking_code)
  end


  # send user message via public profile
  def create_message(sender_id, receiver_id, message_body)
		
		sending_message_thread = MessageThread.find_or_create_by( user_id: sender_id, communicator_id: receiver_id, is_general_thread: true )
		receiving_message_thread = MessageThread.find_or_create_by( user_id: receiver_id, communicator_id: sender_id, is_general_thread: true )
		sending_message_thread.update!(unread: true) if sending_message_thread.unread.blank?
		
		if receiving_message_thread.unread.blank? || receiving_message_thread.status == GlobalConstants::MessageThreads::STATUS[:archived]
			receiving_message_thread.update!(unread: true, status: GlobalConstants::MessageThreads::STATUS[:active])
		end
		sending_message_thread.messages.create!(body: message_body, message_type: GlobalConstants::Messages::TYPE[:sent])
		receiving_message_thread.messages.create!(body: message_body, message_type: GlobalConstants::Messages::TYPE[:received])
		return {sending_message_thread_id: sending_message_thread.id, receiving_message_thread_id: receiving_message_thread.id }
	end
	
	def send_private_message( sender, receiver, message_body )
		message_threads_id = create_message(sender.id, receiver.id, message_body)
		
		if receiver.notifications.where(name: "receive_private_message").present?
			# UserMailer.ride_private_message(self, sender, receiver, message_body, message_threads_id[:receiving_message_thread_id]).deliver
		  if receiver.notifications.notification_status('receive_private_message')
		  	mandrill = MandrillMailer.new
		  	mandrill.ride_private_message(sender,receiver,message_threads_id[:receiving_message_thread_id])
			end
		end
		return message_threads_id[:sending_message_thread_id]
	end

end