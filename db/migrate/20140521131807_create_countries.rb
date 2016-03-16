class CreateCountries < ActiveRecord::Migration
	def change
		create_table :countries do |t|

			t.string :name
			t.string :country_code
			t.string :country_format

			t.timestamps
		end
	end
end
