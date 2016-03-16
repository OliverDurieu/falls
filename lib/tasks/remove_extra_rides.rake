task remove_extra_rides: :environment do
	Ride.where('user_id IS NULL AND created_at < ?', Time.now - 1.day).destroy_all
end
