class Collection < ApplicationRecord
  has_many :assets
  has_many :votes

  def rank_confidence
    raw_confidence = (self.assets.average(:votes_count) / 30) * 100
    
    raw_confidence >= 100 ? 100.to_i : raw_confidence.to_f
  end

  def percentage_voted
    votes = self.votes.pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count
    raw_percent = (total_votes.to_f / self.assets.count).to_f * 100
    
    raw_percent >= 100 ? 100.to_i : raw_percent
  end
end
