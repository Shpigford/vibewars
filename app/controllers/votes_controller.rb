class VotesController < ApplicationController
  def battle
    winner = Asset.find(params[:winner])
    loser = Asset.find(params[:loser])
    
    win_probability = 1/(10.0 ** ((loser.elo_rating.to_f - winner.elo_rating.to_f)/400) + 1)
    win_scoring_point = 1
    lose_scoring_point = 0
   
    winner_new_rating = winner.elo_rating.to_f + (20 * (win_scoring_point - win_probability))
    loser_new_rating = winner.elo_rating.to_f + (20 * (lose_scoring_point - win_probability))

    winner.update_attribute(:elo_rating, winner_new_rating)
    loser.update_attribute(:elo_rating, loser_new_rating)

    Vote.create(winner_id: winner.id, loser_id: loser.id, ip_address: request.remote_ip)

    redirect_to collection_path(winner.collection.address)
  end
end
