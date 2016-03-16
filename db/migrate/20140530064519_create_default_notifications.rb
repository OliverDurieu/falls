class CreateDefaultNotifications < ActiveRecord::Migration
	def change
		create_table :default_notifications do |t|
			t.string :name
			t.string :text
			t.string :medium
			t.timestamps
		end
	end
end
