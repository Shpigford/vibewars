class Wallet < ApplicationRecord
  has_many :assets
  has_many :holdings
  
  validates_uniqueness_of :address
  validates_format_of :address, with: /\A0x[a-fA-F0-9]{40}\z/i, on: :create
end
