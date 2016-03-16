 class MessageThread < ActiveRecord::Base
  belongs_to :ride
  belongs_to :user
  belongs_to :communicator, class_name: :User
  has_many :messages, dependent: :destroy



end
