class AddVerfiedUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :verfied_user, :boolean, default: false
  end
end
