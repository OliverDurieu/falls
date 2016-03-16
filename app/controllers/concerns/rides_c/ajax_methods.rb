# Rides
class RidesC

  module AjaxMethods
    extend ActiveSupport::Concern

    def make_legs
      locations = params[:locations]
      is_round = params[:is_round]
      render partial: 'rides/partials/generate_routes_legs',
             locals: { locations: locations, is_round: is_round }
    end

    def make_schedule
      locations = params[:locations]
      render partial:'rides/partials/generate_ride_steps',
             locals: {locations: locations}
    end 


    
  end
end
