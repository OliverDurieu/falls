class Rating < ActiveRecord::Base

  belongs_to :user
  belongs_to :from_user, class_name: "User"

  validates :star, presence: true
  validates :comment, length: { minimum: 5 }

end