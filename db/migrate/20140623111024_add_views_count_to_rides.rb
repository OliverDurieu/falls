class AddViewsCountToRides < ActiveRecord::Migration
  def change
    add_column :rides, :views_count, :integer, default: 0
  end
end
