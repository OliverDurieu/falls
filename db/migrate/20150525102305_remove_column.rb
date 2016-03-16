class RemoveColumn < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_access_token
  end
end
