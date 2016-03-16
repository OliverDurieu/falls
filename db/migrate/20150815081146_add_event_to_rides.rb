class AddEventToRides < ActiveRecord::Migration
  def change
    add_column :rides, :event, :text
  end
end
