class AddLngLatToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :longitude, :float
    add_column :profiles, :latitude, :float
  end
  def down
    remove_column :profiles, :longitude
    remove_column :profiles, :latitude
  end
end
