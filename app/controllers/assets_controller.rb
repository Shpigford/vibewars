class AssetsController < ApplicationController
  def show
    @collection = Collection.where(slug: params[:collection_id]).first
    @asset = Asset.where(collection_id: @collection.id, token_id: params[:id]).first

    respond_to do |format|
      format.html
      format.json { render json: { collection: @collection, asset: @asset} }
    end
  end
end
