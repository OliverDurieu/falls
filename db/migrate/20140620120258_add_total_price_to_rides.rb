class AddTotalPriceToRides < ActiveRecord::Migration
	def change
		add_column :rides, :total_price, :float
	end
end
