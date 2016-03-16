class CreateLocations < ActiveRecord::Migration
	def change
		create_table :locations do |t|
			t.text :address
			t.float :latitude
			t.float :longitude
			t.string :zipcode
			t.string :city
			t.string :state
			t.string :country
			t.string :countrycode
			t.string :nearbyplace
			t.string :phone
			t.integer :sequence
			t.integer :ride_id
			t.timestamps
		end
	end
end
