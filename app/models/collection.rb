class Collection < ApplicationRecord
  has_many :assets
  has_many :votes

  def rank_confidence
    raw_confidence = (self.assets.average(:votes_count) / 30) * 100
    raw_confidence >= 100 ? 100.to_i : raw_confidence
  end
end
