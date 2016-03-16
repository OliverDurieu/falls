class AddLngToEmptyLocations < ActiveRecord::Migration
  def up
   ride = Location.where(:longitude =>nil)
  	ride.each do |r|
  		if r.address.present?
  			lng = Geocoder.coordinates(r.address).second rescue nil
  			Location.find(r.id).update(longitude: lng)
  		end
  	end
   end
  def down
  end
end
