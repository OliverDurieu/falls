class CreateRides < ActiveRecord::Migration
	def change
		create_table :rides do |t|
			t.text :general_details
			t.text :specific_details
			t.string :source
			t.string :destination
			t.string :your_car
			t.integer :number_of_seats
			t.string :max_luggage_size
			t.integer :leaving_delay
			t.integer :detour_preferences
			t.boolean :is_recurring_trip
			t.boolean :is_details_same
			t.boolean :is_round_trip, default: GlobalConstants::Rides::DEFAULT_ROUND
			t.datetime :departure_date
			t.datetime :return_date
			t.integer :user_id
			t.timestamps
		end
	end
end
