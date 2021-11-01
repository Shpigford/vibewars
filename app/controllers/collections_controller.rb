class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.order(name: :asc)
  end

  def show
    if /\A0x[a-fA-F0-9]{40}\z/i.match(params[:id])
      @collection = Collection.where(address: params[:id]).first
      redirect_to collection_path(@collection.slug)
    else
      @collection = Collection.where(slug: params[:id]).first
      total_rows = @collection.count
      percent_to_call = 100/total_rows.to_f
    end

    compare = @collection.assets.order(votes_count: :asc).limit(50)
    @item_first = compare.sample
    @item_last = compare.sample

    if @item_first == @item_last or @item_first.blank? or @item_last.blank? 
      redirect_to collection_path(@collection.slug)
    end
  end

  def ranking
    if /\A0x[a-fA-F0-9]{40}\z/i.match(params[:id])
      @collection = Collection.where(address: params[:id]).first
      redirect_to ranking_collection_path(@collection.slug)
    else
      @collection = Collection.where(slug: params[:id]).first
    end

    @assets = @collection.assets.where('rank > 0').order(rank: :asc).page params[:page]
  end

  def leaderboard
    @collection = Collection.where(slug: params[:id]).first

    @leaders = @collection.votes.where.not(wallet_id: nil).group(:wallet_id).order(count_all: :desc).count
  end
end
