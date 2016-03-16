class AddSeatsToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :seats, :integer, default: 0, null: false
  end
end
