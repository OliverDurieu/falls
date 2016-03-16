class TransferRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :booking
  has_one :transfer_transaction
end
