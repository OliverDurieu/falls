class TransferTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :transfer_request
end
