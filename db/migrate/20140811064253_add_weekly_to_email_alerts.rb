class AddWeeklyToEmailAlerts < ActiveRecord::Migration
  def change
  	add_column :email_alerts, :weekly, :string, default: 0
  end
end
