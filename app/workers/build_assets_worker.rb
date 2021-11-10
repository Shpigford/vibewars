class BuildAssetsWorker
  include Sidekiq::Worker

  def perform(slug, offset, direction="asc")
    collection = Collection.where(slug: slug).first

    assets = HTTParty.get("https://api.opensea.io/api/v1/assets?order_direction=#{direction}&offset=#{offset}&limit=50&collection=#{collection.slug}").body
    all_assets = JSON.parse(assets)

    all_assets['assets'].each do |asset|
      opensea_asset = Asset.where(opensea_id: asset['id']).first_or_initialize(opensea_id: asset['id'])

      if opensea_asset.new_record?
        opensea_asset.collection_id = collection.id
        opensea_asset.save!
      end

      opensea_asset.token_id = asset['token_id']
      opensea_asset.num_sales = asset['num_sales']
      opensea_asset.background_color = asset['background_color']
      opensea_asset.image_url = asset['image_url']
      opensea_asset.image_original_url = asset['image_original_url']
      opensea_asset.image_thumbnail_url = asset['image_thumbnail_url']
      opensea_asset.animation_url = asset['animation_url']
      opensea_asset.animation_original_url = asset['animation_original_url']
      opensea_asset.name = asset['name']
      opensea_asset.description = asset['description']
      opensea_asset.external_link = asset['external_link']
      opensea_asset.opensea_link = asset['permalink']
      opensea_asset.traits = asset['traits']

      if asset['sell_orders'].present?
        order = asset['sell_orders'].first
        
        opensea_asset.current_sale_price = order['base_price']
        opensea_asset.current_sale_token = order['payment_token_contract']['symbol']
        opensea_asset.current_sale_token_decimals = order['payment_token_contract']['decimals']
      end

      if asset['owner'].present?
        opensea_asset.owner_address = asset['owner']['address'].downcase
        
        wallet = Wallet.where('lower(address) = ?', asset['owner']['address'].downcase).first
        if wallet.present?
          wallet.update(
            opensea_username: asset['owner']['user']['username'],
            opensea_profile_img_url: asset['owner']['profile_img_url']
          )
        end
      end

      opensea_asset.save
    end
  end
end
