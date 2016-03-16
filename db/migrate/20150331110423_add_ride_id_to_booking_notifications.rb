class AddRideIdToBookingNotifications < ActiveRecord::Migration
  def change
    add_column :booking_notifications, :ride_id, :integer
  end
end
