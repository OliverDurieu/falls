class LocationsController < ApplicationController

	before_action :set_ride, only: [:destroy]
	before_action :set_location, only: [:destroy]


	def destroy
		if @location.destroy
			@ride.update!(routing_required: true)
			return render json: "deleted"
		else
			return render json: "failed to delete."
		end
	end

	private
	def set_ride
		@ride = Ride.find(params[:ride_id])
	end

	def set_location
		@location = @ride.locations.find(params[:id])
	end





end