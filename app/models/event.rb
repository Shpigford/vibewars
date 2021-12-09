class Event < ApplicationRecord
  belongs_to :asset
  belongs_to :collection
end
