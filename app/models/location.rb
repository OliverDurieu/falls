class Location < ActiveRecord::Base
	has_one :source_route, class_name: "Route", foreign_key: "source_id"
	has_one :destination_route, class_name: "Route", foreign_key: "destination_id"
	belongs_to :ride

	geocoded_by :address

	default_scope { order('sequence ASC') }

	validates :address, presence: true, if: "ride_type != 'sub_route'"
	validate :check_sub_route

	def check_sub_route
	  if ride_type == GlobalConstants::Locations::RIDE_TYPES[:sub_route] && address.blank?
	      errors.add(:address, "Please fill or remove this field.")
	  end
	end

	def get_route_name
		self.address
	end
end
