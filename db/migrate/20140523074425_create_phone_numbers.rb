class CreatePhoneNumbers < ActiveRecord::Migration
	def change
		create_table :phone_numbers do |t|
			t.string :body
			t.boolean :verified_no
			t.integer :verification_code
			t.integer :public_status
			t.integer :user_id
			t.integer :country_id
			t.timestamps
		end
	end
end
