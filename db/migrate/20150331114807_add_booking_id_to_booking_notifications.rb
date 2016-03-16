class AddBookingIdToBookingNotifications < ActiveRecord::Migration
  def change
    add_column :booking_notifications, :booking_id, :integer
  end
end
