class AddFlagToPreferences < ActiveRecord::Migration
  def change
  	add_column :preferences, :flag, :integer, default: 0
  end
end
