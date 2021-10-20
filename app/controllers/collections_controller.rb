class CollectionsController < ApplicationController
  def index
    @collections = Collection.all.order(name: :asc)
  end

  def show
    @collection = Collection.where(address: params[:id]).first
    @compare = @collection.assets.order(Arel.sql('RANDOM()')).limit(2)
  end
end
