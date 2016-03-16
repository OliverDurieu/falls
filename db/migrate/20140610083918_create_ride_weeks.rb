class CreateRideWeeks < ActiveRecord::Migration
	def change
		create_table :ride_weeks do |t|
			t.boolean :sat
			t.boolean :sun
			t.boolean :mon
			t.boolean :tue
			t.boolean :wed
			t.boolean :thu
			t.boolean :fri
			t.integer :ride_id
			t.integer :date_type
			t.timestamps
			t.belongs_to :ride, index: true
		end
	end
end