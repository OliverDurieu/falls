class AddarchieveToRides < ActiveRecord::Migration
  def change
  	add_column :rides, :archieve, :integer, default: 0
  end
end
