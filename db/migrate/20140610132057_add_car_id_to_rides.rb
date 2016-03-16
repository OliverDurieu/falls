class AddCarIdToRides < ActiveRecord::Migration
	def change
		add_column :rides, :car_id, :integer
		add_column :rides, :full_completed, :integer, default: 0
	end
end
