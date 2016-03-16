class BookingNotifications < ActiveRecord::Migration
  def change
  	create_table :booking_notifications do |t|
		t.string :name
		t.integer :seen
		t.integer :user_id
		t.integer :sender_id
		t.timestamps
	end
  end
end
