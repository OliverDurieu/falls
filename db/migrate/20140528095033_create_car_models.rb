class CreateCarModels < ActiveRecord::Migration
	def change
		create_table :car_models do |t|
			t.string :name
			t.integer :car_maker_id
			t.timestamps
		end
	end
end
