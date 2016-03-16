class CreateCars < ActiveRecord::Migration
	def change
		create_table :cars do |t|
			t.string :car_image
			t.string :image_status
			t.integer :level_of_comfort
			t.integer :number_of_seats
			t.integer :user_id
			t.integer :color_id
			t.integer :car_model_id
			t.integer :car_maker_id
			t.integer :car_category_id
			t.timestamps
		end
	end
end
