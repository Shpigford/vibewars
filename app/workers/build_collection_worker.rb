class BuildCollectionWorker
  include Sidekiq::Worker

  # We need token_id due to OpenSea API limitiations
  def perform(collection_address, token_id)
    # Build collection
    collection = Collection.where(address: collection_address).first_or_initialize(address: collection_address)

    collection.save if collection.new_record?

    asset_collection = HTTParty.get("https://api.opensea.io/api/v1/asset/#{collection.address}/#{token_id}").body
    asset_collection_data = JSON.parse(asset_collection)
    collection_data = asset_collection_data['collection']

    collection.update(
      name: collection_data['name'],
      banner_image_url: collection_data['banner_image_url'],
      creation_date: collection_data['created_date'].to_datetime,
      description: collection_data['description'],
      discord_url: collection_data['discord_url'],
      external_url: collection_data['external_url'],
      image_url: collection_data['image_url'],
      large_image_url: collection_data['large_image_url'],
      short_description: collection_data['short_description'],
      twitter_username: collection_data['twitter_username'],
      instagram_username: collection_data['instagram_username'],
      schema_name: asset_collection_data['asset_contract']['schema_name'],
      symbol: asset_collection_data['asset_contract']['symbol'],
      slug: collection_data['slug'],
      count: collection_data['stats']['count']
    )

    # Kickoff asset workers
    (0..collection_data['stats']['count'].to_i).step(50) do |n|
      BuildAssetsWorker.perform_async(collection_address, n)
    end
  end
end
