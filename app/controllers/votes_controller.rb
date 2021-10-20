class VotesController < ApplicationController
  def show
    asset = Asset.find(params[:id])
   
    Vote.create(asset: asset, ip_address: request.remote_ip)

    redirect_to collection_path(asset.collection.address)
  end
end
