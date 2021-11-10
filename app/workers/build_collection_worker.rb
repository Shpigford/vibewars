class BuildCollectionWorker
  include Sidekiq::Worker

  def perform(slug)
    collection = Collection.where(slug: slug).first_or_initialize(slug: slug)

    collection.save if collection.new_record?

    os_collection = HTTParty.get("https://api.opensea.io/api/v1/collection/#{collection.slug}").body
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

    # Kickoff asset workers
    collection_size = collection_data['stats']['count'].to_i

    if collection_size > 10000
      collection_remainder = collection_size - 10000
      
      (0..10000).step(50) do |n|
        BuildAssetsWorker.perform_async(collection.slug, n)
      end

      (0..collection_remainder).step(50) do |n|
        BuildAssetsWorker.perform_async(collection.slug, n, 'desc')
      end
    else
      (0..collection_size).step(50) do |n|
        BuildAssetsWorker.perform_async(collection.slug, n)
      end
    end

    

    
  end
end
