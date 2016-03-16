class CreateTransferTransactions < ActiveRecord::Migration
  def change
    create_table :transfer_transactions do |t|
      t.integer :amount
      t.string :status
      t.belongs_to :user, index:true
      t.belongs_to :transfer_request, index: true
      t.timestamps
    end
  end
end
