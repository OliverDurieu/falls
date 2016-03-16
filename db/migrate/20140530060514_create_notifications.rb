class CreateNotifications < ActiveRecord::Migration
	def change
		create_table :notifications do |t|
			t.string :name
			t.string :text
			t.string :medium
			t.boolean :status, default: GlobalConstants::Notifications::DEFAULT_STATUS
			t.integer :user_id
			t.timestamps
		end
	end
end
