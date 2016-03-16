class CreateEmailAlerts < ActiveRecord::Migration
  def change
    create_table :email_alerts do |t|
    	t.datetime :travel_date
    	t.integer :user_id
    	t.string :destination
    	t.string :source
      t.timestamps
    end
    add_index :email_alerts, :user_id
  end
end
