class CreateTransections < ActiveRecord::Migration
  def change
    create_table :transections do |t|
      t.string :t_id
      t.string :token
      t.boolean :paid
      t.string :status
      t.integer :amount
      t.string :currency
      t.integer :last4
      t.integer :user_id
      t.string :ride_id
      t.string :reason
      
      t.timestamps
    end
  end
end
