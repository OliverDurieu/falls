class BookingNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :booking
	belongs_to :ride
	scope :seen_message, -> { where(seen: 1) }
	scope :not_seen, -> { where(seen: 0) }
end
