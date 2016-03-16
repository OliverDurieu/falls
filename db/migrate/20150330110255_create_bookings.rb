class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.integer :no_of_seats_booked
      t.datetime :booking_date
      t.integer :user_id
      t.integer :ride_id
      t.timestamps
    end
  end
end
