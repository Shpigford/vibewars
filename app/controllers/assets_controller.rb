class AssetsController < ApplicationController
  def show
    if params[:collection_id].present?
      @collection = Collection.where(slug: params[:collection_id]).first
      @asset = Asset.where(collection_id: @collection.id, token_id: params[:id]).first
    else
      @asset = Asset.find(params[:id])
      @collection = @asset.collection
    end

    respond_to do |format|
      format.html
      format.json { render json: { collection: @collection.attributes.except('traits'), asset: @asset.attributes.except('traits'), rankings: @asset.ranking.attributes.except('id', 'asset_id', 'collection_id') } }
    end
  end
  
  def direct
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: { collection: @asset.collection, asset: @asset, rankings: @asset.ranking.attributes.except('id', 'asset_id', 'collection_id')} }
    end
  end

  def redirect
    @asset = Asset.find(params[:id])

    redirect_to collection_asset_path(@asset.collection.slug, @asset.token_id)
  end
end
