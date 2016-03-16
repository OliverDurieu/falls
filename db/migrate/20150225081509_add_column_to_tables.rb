class AddColumnToTables < ActiveRecord::Migration
  def change
    def_notification = DefaultNotification.create!(name: "ride_post", text: "When  your  ride  is  successfully  posted you  receive a text(free service, only one SMS per ride)", medium: "sms")
    def_notification_1 = DefaultNotification.create!(name: "ride_from_hometown", text: "Whenever someone post a ride from your home town(free service, only one SMS per ride)", medium: "sms")
    User.all.each do |user|
      user.notifications.create(name: def_notification.name, text: def_notification.text, medium: def_notification.medium)
      user.notifications.create(name: def_notification_1.name, text: def_notification_1.text, medium: def_notification_1.medium)
    end
  end
end
