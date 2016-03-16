class AddTotalCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_count, :string
  end
end
