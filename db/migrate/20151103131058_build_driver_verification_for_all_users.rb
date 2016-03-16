class BuildDriverVerificationForAllUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      user.build_driver_verification unless user.driver_verification.present?
    end
  end
end
