class ProcessEventsWorker
  include Sidekiq::Worker

  def perform(slug)
    collection = Collection.where(slug: slug).first

    os_collection = HTTParty.get(
      "https://api.opensea.io/api/v1/events?collection_slug=#{collection.slug}&limit=3",
      headers: { 
        'X-API-KEY': ENV['OPENSEA'].split(',').sample
      }
    ).body
    os_collection_data = JSON.parse(os_collection)

    os_collection_data['asset_events'].count
  end
end
