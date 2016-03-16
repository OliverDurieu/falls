class AddReviewMailSentToRides < ActiveRecord::Migration
  def change
    add_column :rides, :review_mail_sent_to, :boolean, :default => false
  end
end
