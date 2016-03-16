class Car < ActiveRecord::Base

	belongs_to :car_maker
	belongs_to :car_model
	belongs_to :car_category
	belongs_to :user
	belongs_to :color
	has_one :ride
	mount_uploader :car_image, CarImageUploader

	attr_accessor :ride_id

	# validates :car_maker_id, presence: true
	# validates :car_model_id, presence: true
	# validates :color_id, presence: true
	# validates :car_category_id, presence: true

	def car_name
		"#{self.car_maker.name} #{self.car_model.name}"
	end

	def update_car_info(model, make, image)
		if image == nil
			self.update(car_model_id:model, car_maker_id: make)
		else
			self.update(car_model_id:model, car_maker_id: make, car_image: image)
		end	
	end	

	def picture(version=nil)
		if self.car_image.present?
			if version == "profile"
				self.car_image_url(:profile_thumb).to_s
			else
				self.car_image_url
			end
		else
			'profile/car.png'
		end
	end

end
