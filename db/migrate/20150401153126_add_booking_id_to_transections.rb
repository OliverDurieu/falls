class AddBookingIdToTransections < ActiveRecord::Migration
  def change
    add_column :transections, :booking_id, :integer
  end
end
