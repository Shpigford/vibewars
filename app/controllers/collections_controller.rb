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

    # No rating
    no_rating = @collection.assets.where(votes_count: 0).count
    #no_rating = Asset.from('"assets" TABLESAMPLE BERNOULLI(' + percent_to_call.to_s + ')').where(collection_id: @collection.id, votes_count: 0).limit(1)

    if no_rating > 0
      no_rating_item = @collection.assets.where(votes_count: 0).limit(1)
      @item_first = no_rating_item.first

      @compare = Asset.from('"assets" TABLESAMPLE BERNOULLI(' + percent_to_call.to_s + ')').where(collection_id: @collection.id).where.not(id: @item_first.id).limit(1)
      @item_last = @compare.last
    else 
      @compare = Asset.from('"assets" TABLESAMPLE BERNOULLI(' + (percent_to_call * 2).to_s + ')').where(collection_id: @collection.id).limit(2)
      @item_first = @compare.first
      @item_last = @compare.last
    end

    if @item_first == @item_last or @item_first.blank? or @item_last.blank? 
      redirect_to collection_path(@collection.slug)
    end

    votes = Vote.where(collection: @collection.id).pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count

    @percent_done = (total_votes.to_f / @collection.assets.count).to_f * 100

  end

  def ranking
    if /\A0x[a-fA-F0-9]{40}\z/i.match(params[:id])
      @collection = Collection.where(address: params[:id]).first
      redirect_to ranking_collection_path(@collection.slug)
    else
      @collection = Collection.where(slug: params[:id]).first
    end

    @assets = @collection.assets.order(elo_rating: :desc).limit(100)

    # TODO: Duplicate of the method above...need to abstract it out
    votes = Vote.where(collection: @collection.id).pluck(:winner_id, :loser_id)
    total_votes = votes.flatten(1).uniq.count

    @percent_done = (total_votes.to_f / @collection.assets.count).to_f * 100
  end
end
