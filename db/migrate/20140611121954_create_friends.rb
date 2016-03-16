class CreateFriends < ActiveRecord::Migration
	def change
		create_table :friends do |t|

			t.string :name
			t.string :friend_id
			t.integer :user_id

			t.timestamps
		end
	end
end
