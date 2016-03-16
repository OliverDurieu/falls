class UpdateColumnsOfLocation < ActiveRecord::Migration
	def change
		remove_column :rides, :source
		remove_column :rides, :destination
		add_column :rides, :routing_required, :boolean, default: GlobalConstants::Rides::DEFAULT_ROUTING_REQ
		add_column :locations, :ride_type, :string
	end
end
