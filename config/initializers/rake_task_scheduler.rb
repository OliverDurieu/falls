require 'rubygems'
require 'rufus/scheduler'
require 'rake'
# load File.join(Rails.root,'lib','tasks','rate_your_journey.rake')
scheduler = Rufus::Scheduler.new

scheduler.every '24h' do
  puts 'email_dispatched'
  mandrill_mailer = MandrillMailer.new
  mandrill_mailer.contact_us_submit('24hrs LAMULE','24hrs LAMULE','devzaeem.asif@gmail.com','24hrs LAMULE')
  system('rake send_review_mail')
end