class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.belongs_to :booking, index: true
      t.string :transfer_id
      t.integer :amount
      t.string :application_fee_id

      t.timestamps
    end
  end
end
