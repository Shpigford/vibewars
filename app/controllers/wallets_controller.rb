class WalletsController < ApplicationController
  def index
  end

  def show
    @current_wallet = Wallet.find_by(address: params[:id])
    holdings = current_wallet.holdings.pluck(:asset_id)
    @assets = Asset.left_outer_joins(:ranking).where(id: holdings).where('rankings.rank > 0').order('assets.collection_id ASC, rankings.rank ASC')
  end
end
