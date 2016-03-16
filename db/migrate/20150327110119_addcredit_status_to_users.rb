class AddcreditStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_status, :boolean
  end
end
