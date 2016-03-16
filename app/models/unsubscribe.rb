class Unsubscribe < ActiveRecord::Base
	belongs_to :user
	belongs_to :unsubscribe_reason

	validates :unsubscribe_reason_id, presence: true
	validates :comment, presence: true

end
