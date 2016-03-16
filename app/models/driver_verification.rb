class DriverVerification < ActiveRecord::Base
  belongs_to :user
  attr_accessor :f_name, :l_name, :email, :p_num, :pin_email, :pin_mobile,:update_email,
                :car_image, :car_model, :car_make, :car_state, :post_code, :post_address, :avatar
 # validates :pin_email, presence: true                
  # tokenify!(:email_token)
end
