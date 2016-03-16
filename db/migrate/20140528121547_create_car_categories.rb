class CreateCarCategories < ActiveRecord::Migration
	def change
		create_table :car_categories do |t|
			t.string :name
			t.timestamps
		end
	end
end
