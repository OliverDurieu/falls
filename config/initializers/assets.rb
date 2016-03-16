# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.2'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

Rails.application.config.assets.precompile += %w(plugins/gmaps.js posting_a_ride.js gmaps/google.js stripe.js stripe_transfer.js new_design/rides_info.css rides.js new_design/successfully_posted_ride.css ride_info.js ride_info_2.js upload_pic.js user_verification.js driver_verifications.js car_model_select.js)

# Rails.application.config.assets.enabled = true