class CarMaker < ActiveRecord::Base
	has_many :cars
	has_many :car_models
end
