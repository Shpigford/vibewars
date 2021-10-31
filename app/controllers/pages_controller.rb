class PagesController < ApplicationController
  def search
    @collections = Collection.where(
      "name ILIKE :search OR description ILIKE :search OR symbol ILIKE :search", search: "%#{params[:term]}%"
    )
  end

  def leaderboard
    @leaders = Vote.where.not(wallet_id: nil).group(:wallet_id).order(count_all: :desc).count
  end
end
