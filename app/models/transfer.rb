class Transfer < ActiveRecord::Base
  belongs_to :booking
  belongs_to :ride
end
