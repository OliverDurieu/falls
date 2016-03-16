class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :message_thread_id
      t.integer :message_type
      t.integer :parent_id
      t.timestamps
    end
  end

end