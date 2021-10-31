class WalletsController < ApplicationController
  def index
  end

  def show
    @wallet = Wallet.find_by(address: params[:id])
    @assets = Asset.where(owner_address: @wallet.address.downcase).where('rank > 0').order(collection_id: :asc, rank: :asc)
  end
end
