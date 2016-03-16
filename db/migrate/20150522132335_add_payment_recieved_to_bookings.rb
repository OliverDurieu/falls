class AddPaymentRecievedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :payment_recieved, :boolean, :default => false
  end
end
