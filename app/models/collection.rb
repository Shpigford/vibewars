class Collection < ApplicationRecord
  has_many :assets
  has_many :votes
end
