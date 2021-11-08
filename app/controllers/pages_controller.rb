class PagesController < ApplicationController
  def search
    @collections = Collection.where(
      "name ILIKE :search OR description ILIKE :search OR symbol ILIKE :search", search: "%#{params[:term]}%"
    )
  end

  def leaderboard
    @discord = Discordrb::Bot.new(token: ENV['DISCORD'])

    @leaders = Vote.where("wallet_id IS NOT NULL OR discord_user_id IS NOT NULL").group(:wallet_id, :discord_user_id).order(count_all: :desc).count
  end
end
