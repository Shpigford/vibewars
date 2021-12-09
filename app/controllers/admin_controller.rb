class AdminController < ApplicationController
  before_action :check_admin

  def index
    @collection = Collection.new
  end

  def create
    collection = Collection.new(collection_params)

    if collection.save
      BuildCollectionWorker.perform_async(collection.slug)
      ProcessCollectionEventsWorker.perform_in(10.minutes, collection.slug, 'created', (Time.now - 1.year).to_i)
      ProcessCollectionEventsWorker.perform_in(10.minutes, collection.slug, 'successful', (Time.now - 1.year).to_i)
      ProcessCollectionEventsWorker.perform_in(10.minutes, collection.slug, 'cancelled', (Time.now - 1.year).to_i)
    end

    redirect_to admin_index_path
  end

private
  def check_admin
    redirect_to root_path unless @current_wallet and @current_wallet.admin === true
  end

  def collection_params
    params.require(:collection).permit(:slug)
  end

end
