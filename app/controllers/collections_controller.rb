class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.order(name: :asc)
  end

  def show
    @collection = Collection.where(address: params[:id]).first
    @compare = @collection.assets.order(Arel.sql('RANDOM()')).limit(2)
    @item_first = @compare.first
    @item_last = @compare.last
  end

  def ranking
    @collection = Collection.where(address: params[:id]).first
    @assets = @collection.assets.order(elo_rating: :desc).limit(100)
  end
end
