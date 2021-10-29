class AssetsController < ApplicationController
  def show
    @collection = Collection.where(slug: params[:collection_id]).first
    @asset = Asset.where(collection_id: @collection.id, token_id: params[:id]).first

    raw_confidence = (@collection.assets.average(:votes_count) / 30) * 100
    @ranking_confidence = raw_confidence >= 100 ? 100.to_i : raw_confidence
  end
end
