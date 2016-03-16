class AddDefaultValueToVerifiedAttribute < ActiveRecord::Migration
  # def change
  # 	 change_column :driver_verifications, :verified, :boolean, :default => false
  # end

def up
  change_column_default :driver_verifications, :verified, false
end

def down
	change_column_default :driver_verifications, :verified, nil
end

end

