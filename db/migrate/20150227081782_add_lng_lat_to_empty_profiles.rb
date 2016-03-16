class AddLngLatToEmptyProfiles < ActiveRecord::Migration
  def up
   profile = Profile.all
  	profile.each do |p|
  		if p.city.present? && p.longitude == "" || !p.longitude.present?
  			params = Geocoder.coordinates(p.city) rescue nil
        if params
  			 Profile.find(p.id).update(longitude: params[0], latitude: params[1])
        end
  		end
  	end
   end
  def down
  end
end
