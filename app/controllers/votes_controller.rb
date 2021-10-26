class VotesController < ApplicationController
  def battle
    winner = Asset.find(params[:winner])
    loser = Asset.find(params[:loser])
    collection = winner.collection

    ip_last_voted = Vote.where(ip_address: request.remote_ip).order(created_at: :desc).limit(1).first
    ip_winner_loser_last_voted = Vote.where('winner_id=? OR loser_id=? OR winner_id=? OR loser_id=?', winner.id, loser.id, loser.id, winner.id).where(ip_address: request.remote_ip).order(created_at: :desc).limit(1).first

    if ip_last_voted.present?
      seconds_since_last_voted = Time.current - ip_last_voted.created_at
    end

    if ip_winner_loser_last_voted.present?
      seconds_since_last_winner_loser_voted = Time.current - ip_winner_loser_last_voted.created_at
    end

    # Prevent counting duplicate vote if > 15 minutes 
    if ((ip_winner_loser_last_voted.present? and seconds_since_last_winner_loser_voted < (60 * 15)) or (ip_last_voted.present? and seconds_since_last_voted < 2)) and (winner.votes_count > 5 or loser.votes_count > 5)
      redirect_to collection_path(collection.slug)
    else      
      win_probability = 1/(10.0 ** ((loser.elo_rating.to_f - winner.elo_rating.to_f)/400) + 1)
      win_scoring_point = 1
      lose_scoring_point = 0
    
      winner_new_rating = winner.elo_rating.to_f + (20 * (win_scoring_point - win_probability))
      loser_new_rating = loser.elo_rating.to_f + (20 * (lose_scoring_point - win_probability))

      winner.update_attribute(:elo_rating, winner_new_rating)
      loser.update_attribute(:elo_rating, loser_new_rating)

      Vote.create(winner_id: winner.id, loser_id: loser.id, ip_address: request.remote_ip, collection: winner.collection)
      
      winner.increment!(:votes_count)
      loser.increment!(:votes_count)

      redirect_to collection_path(collection.slug)
    end
  end
end
