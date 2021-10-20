class VotesController < ApplicationController
  def battle
    asset = Asset.find(params[:winner])
   
    Vote.create(winner_id: params[:winner], loser_id: params[:loser], ip_address: request.remote_ip)

    redirect_to collection_path(asset.collection.address)
  end
end
