class AddDistanceAndTimeToRides < ActiveRecord::Migration
	def change
		add_column :rides, :total_distance, :string
		add_column :rides, :total_time, :string
	end
end
