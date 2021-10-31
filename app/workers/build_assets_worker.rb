class BuildAssetsWorker
  include Sidekiq::Worker

  def perform(address, slug, offset)
    collection = Collection.where(address: address, slug: slug).first
    # https://api.opensea.io/api/v1/assets?asset_contract_addresses=0x3769c5700da07fe5b8eee86be97e061f961ae340&order_direction=asc&offset=0&limit=50

    assets = HTTParty.get("https://api.opensea.io/api/v1/assets?asset_contract_addresses=#{address}&order_direction=asc&offset=#{offset}&limit=50&collection=#{collection.slug}").body
    all_assets = JSON.parse(assets)

    all_assets['assets'].each do |asset|
      opensea_asset = Asset.where(opensea_id: asset['id']).first_or_initialize(opensea_id: asset['id'])

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

      if asset['sell_orders'].present?
        order = asset['sell_orders'].first
        opensea_asset.update(
          current_sale_price: order['base_price'],
          current_sale_token: order['payment_token_contract']['symbol'],
          current_sale_token_decimals: order['payment_token_contract']['decimals']
        )
      end

      if asset['owner'].present?
        opensea_asset.update(
          owner_address: asset['owner']['address'].downcase
        )
        
        wallet = Wallet.where('lower(address) = ?', asset['owner']['address'].downcase).first
        if wallet.present?
          wallet.update(
            opensea_username: asset['owner']['user']['username'],
            opensea_profile_img_url: asset['owner']['profile_img_url']
          )
        end
      end
    end
  end
end
