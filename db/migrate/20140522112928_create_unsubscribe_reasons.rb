class CreateUnsubscribeReasons < ActiveRecord::Migration
	def change
		create_table :unsubscribe_reasons do |t|

			t.string :name
			t.timestamps
		end
	end
end
