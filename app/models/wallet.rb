class Wallet < ApplicationRecord
  belongs_to :vote
  validates_uniqueness_of :address
  validates_format_of :address, with: /\A0x[a-fA-F0-9]{40}\z/i, on: :create
end
