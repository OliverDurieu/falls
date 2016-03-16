class CreateDriverVerifications < ActiveRecord::Migration
  def change
    create_table :driver_verifications do |t|
      t.belongs_to :user, index: true
      t.string :email_token
      t.string :phone_token
      t.boolean :verified

      t.timestamps
    end
  end
end
