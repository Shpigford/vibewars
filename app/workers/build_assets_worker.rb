class BuildAssetsWorker
  include Sidekiq::Worker

  def perform(address, offset)
    collection = Collection.where(address: address).first
    # https://api.opensea.io/api/v1/assets?asset_contract_addresses=0x3769c5700da07fe5b8eee86be97e061f961ae340&order_direction=asc&offset=0&limit=50

    assets = HTTParty.get("https://api.opensea.io/api/v1/assets?asset_contract_addresses=#{address}&order_direction=asc&offset=#{offset}&limit=50").body
    all_assets = JSON.parse(assets)

    if all_assets.blank? || all_assets['assets'].blank?
      Rails.logger.warn "No assets for address=#{address} offset=#{offset} all_assets=#{all_assets.inspect}"
      return
    end

    all_assets['assets'].each do |asset|
      opensea_asset = Asset.where(opensea_id: asset['id']).first_or_initialize(opensea_id: asset['id'])
      Rails.logger.debug "Updating opensea_asset_id=#{opensea_asset.opensea_id} new_record?=#{opensea_asset.new_record?}"

      if opensea_asset.new_record?
        opensea_asset.collection_id = collection.id
        opensea_asset.save!
      end

      opensea_asset.update(
        token_id: asset['token_id'],
        num_sales: asset['num_sales'],
        background_color: asset['background_color'],
        image_url: asset['image_url'],
        image_original_url: asset['image_original_url'],
        image_thumbnail_url: asset['image_thumbnail_url'],
        animation_url: asset['animation_url'],
        animation_original_url: asset['animation_original_url'],
        name: asset['name'],
        description: asset['description'],
        external_link: asset['external_link'],
        opensea_link: asset['permalink']
      )
    end
  end
end
