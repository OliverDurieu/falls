class RenameVerifedUserField < ActiveRecord::Migration
  def change
    rename_column :users, :verfied_user, :verified_credentials
  end
end
