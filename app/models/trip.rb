class Trip
	include ActiveModel::Validations
  	include ActiveModel::Conversion
  	extend ActiveModel::Naming
	
	attr_accessor :ride_id, :locations, :price, :trip_price, :is_round, :dir, :time, :user_id, :dir, :src, :dest, :date
	def initialize
		locations = []
	end
end