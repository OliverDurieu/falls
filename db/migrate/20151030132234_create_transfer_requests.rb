class CreateTransferRequests < ActiveRecord::Migration
  def change
    create_table :transfer_requests do |t|
      t.integer :amount
      t.belongs_to :user, index:true
      t.belongs_to :booking, index: true
      t.timestamps
    end
  end
end
