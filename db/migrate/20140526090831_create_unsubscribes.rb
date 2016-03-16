class CreateUnsubscribes < ActiveRecord::Migration
	def change
		create_table :unsubscribes do |t|
			t.text :comment
			t.boolean :recommend
			t.integer :user_id
			t.integer :unsubscribe_reason_id
			t.timestamps
		end
	end
end