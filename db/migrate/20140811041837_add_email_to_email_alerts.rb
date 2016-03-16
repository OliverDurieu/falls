class AddEmailToEmailAlerts < ActiveRecord::Migration
  def change
  	add_column :email_alerts, :email, :string
  end
end
