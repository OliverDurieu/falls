class CreatePreferences < ActiveRecord::Migration
	def change
		create_table :preferences do |t|
			t.integer :chattiness, default: GlobalConstants::Preferences::DEFAULT_LEVEL
			t.integer :music, default: GlobalConstants::Preferences::DEFAULT_LEVEL
			t.integer :smoking, default: GlobalConstants::Preferences::DEFAULT_LEVEL
			t.integer :pets, default: GlobalConstants::Preferences::DEFAULT_LEVEL
			t.integer :user_id
			t.timestamps
		end
	end
end
