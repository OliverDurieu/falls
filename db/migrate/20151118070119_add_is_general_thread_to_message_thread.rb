class AddIsGeneralThreadToMessageThread < ActiveRecord::Migration
  def change
    add_column :message_threads, :is_general_thread, :boolean, default: false
  end
end
