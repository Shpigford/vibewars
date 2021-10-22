class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.order(name: :asc)
  end

  def show
    @collection = Collection.where(address: params[:id]).first
    

    # No rating
    no_rating = @collection.assets.where(elo_rating: 1600).order(Arel.sql('RANDOM()')).limit(1)

    if no_rating.present?
      @item_first = no_rating.first

      @compare = @collection.assets.where.not(id: @item_first.id).order(Arel.sql('RANDOM()')).limit(1)
      @item_last = @compare.last
    else 
      @compare = @collection.assets.order(Arel.sql('RANDOM()')).limit(2)
      @item_first = @compare.first
      @item_last = @compare.last
    end

    votes = Vote.where(collection: @collection.id).pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count

    @percent_done = (total_votes.to_f / @collection.assets.count).to_f * 100

  end

  def ranking
    @collection = Collection.where(address: params[:id]).first
    @assets = @collection.assets.order(elo_rating: :desc).limit(100)

    # TODO: Duplicate of the method above...need to abstract it out
    votes = Vote.where(collection: @collection.id).pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count

    @percent_done = (total_votes.to_f / @collection.assets.count).to_f * 100
  end
end
