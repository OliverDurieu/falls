class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :user_id
      t.integer :from_user_id
      t.string :user_type
      t.integer :star
      t.text :comment
      t.integer :driving_skill
      t.timestamps
    end
  end
end
