# Rides
class RidesC

  module SocialMethods
    extend ActiveSupport::Concern

    def share_on_facebook
      ride = Ride.find(params[:id])
      route = ride.show_sorce_destination_route.gsub(', Australia','')
      redirect_to URI.encode('https://www.facebook.com/dialog/feed?app_id=223943261150250&link=http://www.lamule.com.au/rides/'+ride.id.to_s+'&picture=http://eduleaf-development.s3.amazonaws.com/uploads/lamule_meta_image_large_2.png&name=  Who is keen to join me on my journey? I’m cruising from '+route+'&caption=Departure Time '+ride.departure_date.to_s+'&description='+ride.number_of_seats.to_s+' Seats left and '+ride.total_price.to_s+'$ per passenger&redirect_uri=http://www.lamule.com.au/rides&display=popup')
    end
  end
end
