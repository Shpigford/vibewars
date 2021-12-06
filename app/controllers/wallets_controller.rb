class WalletsController < ApplicationController
  def index
  end

  def show
    @wallet = Wallet.find_by(address: params[:id])
    @assets = Asset.left_outer_joins(:ranking).where(owner_address: @wallet.address.downcase).where('rankings.rank > 0').order('assets.collection_id ASC, rankings.rank ASC')
  end
end
