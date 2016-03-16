class AddMessagetoTransections < ActiveRecord::Migration
  def change
    add_column :transections, :failure_message, :string
  end
end
