class WalletsController < ApplicationController
  def index
  end

  def show
    @current_wallet = Wallet.find_by(address: params[:id])
    @assets = Asset.left_outer_joins(:ranking).where(owner_address: @current_wallet.address.downcase).where('rankings.rank > 0').order('assets.collection_id ASC, rankings.rank ASC')
  end
end
