class Route < ActiveRecord::Base
  validates :price, presence: true
  validates_numericality_of :price, :greater_than => 0
  validates :seats, :numericality => { only_integer: true, less_than: 8 }
	belongs_to :ride
	belongs_to :source, class_name: "Location"
	belongs_to :destination, class_name: "Location"
end
          