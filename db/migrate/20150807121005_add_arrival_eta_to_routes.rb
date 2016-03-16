class AddArrivalEtaToRoutes < ActiveRecord::Migration
  def change
    add_column :routes, :arrival_time, :datetime
  end
end
