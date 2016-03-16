json.array!(@rides) do |ride|
	json.extract! ride, :id
	json.url ride_url(ride, format: :json)
end
