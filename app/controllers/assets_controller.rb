class AssetsController < ApplicationController
  def show
    @collection = Collection.where(slug: params[:collection_id]).first
    @asset = Asset.where(token_id: params[:id]).first
  end
end
