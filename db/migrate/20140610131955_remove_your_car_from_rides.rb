class RemoveYourCarFromRides < ActiveRecord::Migration
	def change
		remove_column :rides, :your_car, :string
	end
end
