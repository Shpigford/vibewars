class VotesController < ApplicationController
  def battle
    winner = Asset.find(params[:winner])
    loser = Asset.find(params[:loser])
    collection = winner.collection

    recent_vote = Vote.where('winner_id=? OR loser_id=? OR winner_id=? OR loser_id=?', winner.id, loser.id, loser.id, winner.id).where(collection: collection).where('created_at > ?', Time.current - 5.minutes).count

    ip_last_voted = Vote.where(ip_address: request.remote_ip).order(created_at: :desc).limit(1).first
    # ip_winner_loser_last_voted = Vote.where('winner_id=? OR loser_id=? OR winner_id=? OR loser_id=?', winner.id, loser.id, loser.id, winner.id).where(ip_address: request.remote_ip).order(created_at: :desc).limit(1).first

    if ip_last_voted.present?
      seconds_since_last_voted = Time.current - ip_last_voted.created_at
    end

    # if ip_winner_loser_last_voted.present?
    #   seconds_since_last_winner_loser_voted = Time.current - ip_winner_loser_last_voted.created_at
    # end

    # Prevent counting duplicate vote if > 15 minutes 
    if ((recent_vote > 0) or (ip_last_voted.present? and seconds_since_last_voted < 1.5))
      redirect_to collection_path(collection.slug)
    else      
      win_probability = 1/(10.0 ** ((loser.elo_rating.to_f - winner.elo_rating.to_f)/400) + 1)
      win_scoring_point = 1
      lose_scoring_point = 0
    
      winner_new_rating = winner.elo_rating.to_f + (20 * (win_scoring_point - win_probability))
      loser_new_rating = loser.elo_rating.to_f + (20 * (lose_scoring_point - win_probability))

      winner.update_attribute(:elo_rating, winner_new_rating)
      loser.update_attribute(:elo_rating, loser_new_rating)

      if cookies[:wallet].present? and cookies[:wallet] != 'undefined'
        wallet = Wallet.find_or_create_by(address: cookies[:wallet])
        wallet = wallet.id
      else
        wallet = nil
      end

      Vote.create(winner_id: winner.id, loser_id: loser.id, ip_address: request.remote_ip, collection: winner.collection, wallet_id: wallet)
      
      winner.increment!(:votes_count)
      loser.increment!(:votes_count)

      redirect_to collection_path(collection.slug)
    end
  end
end
