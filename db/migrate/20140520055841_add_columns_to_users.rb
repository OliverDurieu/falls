class AddColumnsToUsers < ActiveRecord::Migration
	def change
		add_column :users, :name, :string
		add_column :users, :provider, :string
		add_column :users, :uid, :string
		add_column :users, :gender, :string
		add_column :users, :first_name, :string
		add_column :users, :last_name, :string
		add_column :users, :birth_year, :integer
		add_column :users, :email_verified, :boolean
		add_column :users, :receive_updates, :boolean

	end
end
