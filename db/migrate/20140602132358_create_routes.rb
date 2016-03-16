class CreateRoutes < ActiveRecord::Migration
	def change
		create_table :routes do |t|
			t.float :price
			t.integer :source_id
			t.integer :destination_id
			t.integer :ride_id
			t.timestamps
		end
	end
end
