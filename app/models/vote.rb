class Vote < ApplicationRecord
  belongs_to :collection
  has_many :wallets
end
