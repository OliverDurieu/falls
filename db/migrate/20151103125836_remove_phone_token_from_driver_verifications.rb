class RemovePhoneTokenFromDriverVerifications < ActiveRecord::Migration
  def change
    remove_column :driver_verifications, :phone_token, :string
  end
end
