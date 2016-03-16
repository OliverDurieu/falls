class Profile < ActiveRecord::Base
	require 'file_size_validator'
	belongs_to :user
	belongs_to :country

	geocoded_by :city
	after_validation :lat_changed?

	attr_accessor :check_photo
	mount_uploader :photo, ProfilePhotoUploader

	validates :photo, :file_size =>
			{
					:maximum => 2.0.megabytes.to_i
			}, :if => "check_photo.present?"

	before_save :handle_picture

	def handle_picture
		self.remote_photo = nil if self.photo.present?
	end

	def get_displayed_as
		self.displayed_as == "1" ? self.user.display_first_last_name : self.user.display_first_name
	end

	def is_picture?
		self.photo.present? || self.remote_photo.present?
	end

	def lat_changed?
		if self.city.present?
			if (self.city_changed?)
		        if !(self.latitude_changed?)
		            self.errors.add(:city, "is not valid")
		            return false
		        end
	    	elsif self.postcode.present?
	    		get_cord_zip
	    	end
	    elsif self.postcode.present?
	    	get_cord_zip
	    end
	end

	def get_cord_zip
		c = Country.find(4)
		lng_lat = Geocoder.search("#{self.postcode}+#{c.name}")
		if lng_lat.present?
			lng = lng_lat.first.data["geometry"]["location"]["lng"]
			lat = lng_lat.first.data["geometry"]["location"]["lat"]
			city = lng_lat.first.data["formatted_address"]
			self.update_columns(longitude: lng, latitude: lat, city: city)
		else
		 	self.errors.add(:postcode, "is not valid")
	        return false
		end
	end

	def update_verification_information(postcode, address, image)
		if image != nil
  		self.update(postcode: postcode, address_1: address, photo: image)
  	else
  		self.update(postcode: postcode, address_1: address)
  	end	
  end	
	
	def picture(version="default")
		if self.remote_photo.present?
			if version == "profile" || version == "driver"
				"#{self.remote_photo}?type=large"
			elsif version == "inbox"
				"#{self.remote_photo}?type=normal"
			elsif version == "public_profile"
				"#{self.remote_photo}?type=large"
			elsif version == "chat"
				"#{self.remote_photo}?type=normal"
			elsif version == "default"
				"#{self.remote_photo}?type=large"
			else
				"#{self.remote_photo}?type=large"
			end
		elsif self.photo.present?
			if version == "profile" || version == "driver"
				self.photo_url(:profile_thumb)
			elsif version == "inbox" 
				self.photo_url(:inbox_thumb)
			elsif version == "public_profile"
				self.photo_url(:public_profile)
			elsif version == "chat"
				self.photo_url(:chat)			
			elsif version == "default"
				self.photo_url
			else
				self.photo_url
			end

		else
			if version == "driver"
				'/user/icon-man-108.png'
			elsif version == "public_profile"
				'user/icon-man-144.png'
			elsif version == "inbox"
				'user/icon-man-54.png'
			elsif version == "chat"
				'user/icon-man-72.png'	
			else
				'user/icon-man-108.png'
				# '/user/icon-man-108.png'
			end
		end
	end

end
