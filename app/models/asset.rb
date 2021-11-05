class Asset < ApplicationRecord
  belongs_to :collection
  has_many :traits
end
