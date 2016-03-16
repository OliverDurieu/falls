class CarsController < ApplicationController

	layout "profile", only: [:index, :new, :edit, :update, :create]

	before_filter :load_cars, only: [:index]
	before_filter :load_car, only: [:edit, :update, :destroy, :upload_image]

	def index
	end

	def new
		@car = current_user.cars.build
		if params[:rid].present? && Ride.find(params[:rid])
			session[:ride_id] = params[:rid]
			session[:comming_path] = params[:fr]
		end
	end

	def create
		@car = current_user.cars.build(car_params)
		if @car.save
			# if params[:car][:ride_id]
			# 	# session.delete(:ride_id)
			# 	ride = Ride.find(params[:car][:ride_id]) rescue nil
			# 	if ride.present?
			# 		ride.update!(car_id: @car.id)
			# 		returing_path = session[:comming_path]
			# 		session.delete(:comming_path)
			# 		if returing_path == "of2"
			# 			redirect_to "/#{ride.id}/offer-seats/2"
			# 		elsif returing_path == "rs"
			# 			redirect_to ride_path(ride.id)
			# 		else
			# 			redirect_to cars_path, notice: t('.succeed')
			# 		end
			# 	else
			# 		redirect_to cars_path, notice: t('.succeed')
			# 	end
			# else
			# 	redirect_to cars_path, notice: t('.succeed')
			# end
			# flash[:notice] = t('.success')
		else
			# flash[:danger] = t('.failed')
		end
		respond_to do |format|
			format.js {}
			format.html { redirect_to :back}
		end	
	end

	def update
		if @car.update(car_params)
			redirect_to cars_path, notice: t('.succeed')
		else
			flash[:danger] = t('.failed')
			render 'edit'
		end
	end

	def destroy
		if @car.destroy
			redirect_to cars_path, notice: t('.succeed')
		else
			flash[:danger] = t('.failed')
			redirect_to cars_path
		end
	end

	def upload_image
		if @car.update(car_image_params)
			if params[:rid].present?
				redirect_to ride_path(params[:rid])
			else	
				redirect_to cars_path, notice: t('.succeed')
			end
		else
			if params[:rid].present?
				redirect_to ride_path(params[:rid])
			else	
				flash[:danger] = t('.failed')
				redirect_to cars_path
			end
		end

	end


	private
	def load_cars
		@cars = current_user.cars.includes(:car_model, :car_maker, :car_category)
	end

	def load_car
		@car = current_user.cars.find(params[:id])
	end


	def car_params
		params.require(:car).permit!
		# params.require(:car).permit(:car_maker_id, :car_model_id, :color_id, :number_of_seats, :level_of_comfort, :car_category_id, :ride_id)
	end

	def car_image_params
		params.require(:car).permit(:car_image)
	end
end
