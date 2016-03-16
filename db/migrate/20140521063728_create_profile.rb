class CreateProfile < ActiveRecord::Migration
	def change
		create_table :profiles do |t|
			t.text :mini_bio
			t.text :address_1
			t.text :address_2
			t.string :displayed_as
			t.string :photo
			t.string :postcode
			t.string :city
			t.integer :country_id
			t.integer :user_id

			t.timestamps
		end
	end
end
