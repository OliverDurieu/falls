class AddFlagToEmailAlerts < ActiveRecord::Migration
  def change
  		add_column :email_alerts, :flag, :integer, default: 0
  end
end
