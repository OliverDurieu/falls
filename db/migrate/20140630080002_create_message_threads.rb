class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|
      t.integer :user_id
      t.integer :communicator_id
      t.integer :ride_id
      t.integer :status, default: GlobalConstants::MessageThreads::STATUS[:active]
      t.boolean :unread, default: true
      t.timestamps
    end
  end
end
