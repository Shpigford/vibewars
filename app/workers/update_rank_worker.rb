class UpdateRankWorker
  include Sidekiq::Worker

  def perform(collection_id)
    collection = Collection.find(collection_id)

    collection.assets.order(elo_rating: :desc).each_with_index do |asset, index|
      asset.update(rank: index + 1);
    end
  end
end
