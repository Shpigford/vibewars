class Collection < ApplicationRecord
  has_many :assets
  has_many :votes
  has_many :rankings

  def rank_confidence
    raw_confidence = self.assets.left_outer_joins(:ranking).average('rankings.progress')
  end

  def percentage_voted
    votes = self.votes.pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count
    raw_percent = (total_votes.to_f / self.assets.count).to_f * 100
    
    raw_percent >= 100 ? 100.to_i : raw_percent
  end
end
