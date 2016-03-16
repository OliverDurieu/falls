class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
    	t.integer :user_id
    	t.integer :ride_id
    	t.integer :no_of_views, default: 1
      	t.timestamps
    	
  	end
  remove_column :rides, :views_count
	add_index :visitors, :ride_id
	add_index :visitors, :user_id
  end
end
