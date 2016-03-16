module GlobalConstants
	# This is a constants file that doesn't require a server restart and you can use these constants like GlobalConstants::STORAGE
	GENDER_TYPES = [['Male', 'male'], ['Female', 'female']]
	DEFAULT_COUNTRY = 'Australia'
	TWILIO_ID = 'ACfd7feff29682506f4063c07691992803'
	TWILIO_TOKEN = '7560e26512de1d95327273b6bbad899c' 
	FROM_NUMBER = '+19377190052'
	FB_APP_LIKEPAGE_URL = 'https://www.facebook.com/pages/La-Mule-Community/710768758986595'
	ADMIN_EMAIL ='customersupport@lamule.com.au'
	LAMULE_TRANSFER_PERCENTAGE = 0.85

	# Mailchimp section
	MAILCHIMP_APIKEY = '4f05a246c6ad74b922e84e54bdf5d03a-us8'
	MAILCHIMP_LISTID = '0009f801bd'
	CAR_COMFORT_LEVEL = [["Basic", 0], ["Normal", 1], ["Comfortable", 2], ["Luxury", 3]]
	class Preferences
		DEFAULT_LEVEL = 1
		LEVELS_TEXT = ["Not Allowed", "Sometimes Allowed", "No Problem"]
	end
	class Notifications
		DEFAULT_STATUS = true
	end
	class Rides
		DEFAULT_ROUND = true
		DEFAULT_ROUTING_REQ = true
		MAX_LUGGAGE_SIZE = [["Small", "small"], ["Medium", "medium"], ["Big", "big"]]
		LEAVING_DELAY = [["Right on time", 0], ["In a 15 minute window", 1], ["In a 30 minute window", 2], ["In a 1 hour window", 3], ["In a 2 hour window", 4]]
		DETOUR_PREFERENCES = [["None", 0], ["15 minute detour, max.", 1], ["30 minute detour, max.", 2], ["Anything is fine", 3]]
	end
	class Locations
		RIDE_TYPES = { source: "source", destination: "destination", sub_route: "sub_route" }
	end
	class Ride_weeks
		DATE_TYPES = { outbound_week: 1, return_week: 2 }
	end
	class Ride_months
		DATE_TYPES = { outbound_month: 1, return_month: 2 }
	end
	class Messages
		TYPE = { received: 0, sent: 1}
	end
	class MessageThreads
		STATUS = { active: 0, archived: 1}
	end
end
