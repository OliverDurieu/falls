class AddRideIdToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :ride_id, :integer, references: :rides
  end
end
