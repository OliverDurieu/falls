class Notification < ActiveRecord::Base
	belongs_to :user
	# scope :sms_notifications, -> { where(medium: "sms") }
	scope :email_notifications, -> { where(medium: "email") }
	scope :facebook_notifications, -> { where(medium: "facebook") }

	def self.sms_notifications
		result = []
		data = where(medium: "sms")
		data.each do |no|
			unless result.map(&:name).include?(no.name)
				result << no
			end
		end
		result
	end

	def self.notification_status(name)
   	n = where(name: name).first
  	if n
  		n.status
  	else
  		false
  	end
  end

end
