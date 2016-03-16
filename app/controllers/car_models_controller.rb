 class CarModelsController < ApplicationController
	def index
		@car_maker = CarMaker.find(params[:car_maker_id])
		@car_models = @car_maker.car_models
		return render partial: 'index'
	end

end
