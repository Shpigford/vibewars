class BuildAssetsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 8

  def perform(slug, cursor, direction="asc")
    collection = Collection.where(slug: slug).first

    assets = HTTParty.get("https://api.opensea.io/api/v1/assets?order_direction=#{direction}&cursor=#{cursor}&limit=50&collection=#{collection.slug}", 
      headers: { 
        'X-API-KEY': ENV['OPENSEA'].split(',').sample 
      }
    ).body

    if assets.include?("Access denied")
      raise "Access denied."
    else
      all_assets = JSON.parse(assets)
    end

    if all_assets['detail'].present? and all_assets['detail'] == "Request was throttled."
      raise "Request was throttled."
    else
      all_assets['assets'].each do |asset|
        #######################################################################
        # If asset has traits that match the collection filter, DO NOT add them
        #######################################################################
        unless collection.filter_traits.present? && asset['traits'][0] >= collection.filter_traits

          opensea_asset = Asset.where(opensea_id: asset['id']).first_or_initialize(opensea_id: asset['id'])

          if opensea_asset.new_record?
            opensea_asset.collection_id = collection.id
            opensea_asset.save!

            FetchImageWorker.perform_in(10.seconds, opensea_asset.id)
          end

          ranking = Ranking.where(asset_id: opensea_asset.id).first_or_create(asset_id: opensea_asset.id, collection_id: collection.id)

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
              wallet.opensea_username = asset['owner']['user']['username'] if asset['owner']['user'].present?
              wallet.opensea_profile_img_url = asset['owner']['profile_img_url']
              wallet.save
            end
          end

          opensea_asset.save
        end
      end

      BuildAssetsWorker.perform_async(collection.slug, all_assets['next']) if all_assets['next'].present?
    end

  end
end
