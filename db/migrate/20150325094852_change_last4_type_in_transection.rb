class ChangeLast4TypeInTransection < ActiveRecord::Migration
  def up
   change_column :transections, :last4, :string
  end

  def down
   change_column :transections, :last4, :integer
  end
end
