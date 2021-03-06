class BuildCollectionWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, lock: :while_executing, on_conflict: :reject

  def perform(slug)
    collection = Collection.where(slug: slug).first_or_initialize(slug: slug)

    collection.save if collection.new_record?

    os_collection = HTTParty.get(
      "https://api.opensea.io/api/v1/collection/#{collection.slug}",
      headers: { 
        'X-API-KEY': ENV['OPENSEA'].split(',').sample
      }
    ).body
    os_collection_data = JSON.parse(os_collection)
    collection_data = os_collection_data['collection']
    primary_contract = collection_data['primary_asset_contracts'][0]

    if primary_contract.present?
      collection.address = primary_contract['address']
      collection.schema_name = primary_contract['schema_name']
      collection.symbol = primary_contract['symbol']
    end

    collection.name = collection_data['name']
    collection.banner_image_url = collection_data['banner_image_url']
    collection.creation_date = collection_data['created_date'].to_datetime
    collection.description = collection_data['description']
    collection.discord_url = collection_data['discord_url']
    collection.external_url = collection_data['external_url']
    collection.image_url = collection_data['image_url']
    collection.large_image_url = collection_data['large_image_url']
    collection.short_description = collection_data['short_description']
    collection.twitter_username = collection_data['twitter_username']
    collection.instagram_username = collection_data['instagram_username']
    collection.count = collection_data['stats']['count']
    collection.traits = collection_data['traits']

    collection.save

    BuildAssetsWorker.perform_async(collection.slug, nil)
  end
end
