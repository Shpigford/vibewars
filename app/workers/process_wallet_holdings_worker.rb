class ProcessWalletHoldingsWorker
  include Sidekiq::Worker

  def perform(wallet_id)
    wallet = Wallet.find(wallet_id)

    addresses = Collection.pluck(:address).uniq.compact.map { |address| "asset_contract_addresses=#{address}" }.join("&")

    more_assets = true
    offset = nil

    Holding.where(wallet: wallet).delete_all

    until more_assets === false do
    
      begin
        key = ENV['OPENSEA'].split(',').sample
        puts key

        os_collection = HTTParty.get(
          "https://api.opensea.io/api/v1/assets?owner=#{wallet.address}&#{addresses}&order_direction=desc&cursor=#{offset}&limit=50",
          headers: { 
            'X-API-KEY': key
          }
        ).body
        os_collection_data = JSON.parse(os_collection)
      rescue
        if os_collection_data.include?('Request was throttled')
          puts "Throttled"
          sleep(30)
        else
          sleep(5)
        end

        retry
      end

      if os_collection_data['assets'].blank?
        more_assets = false
      else
        os_assets = os_collection_data['assets']
        
        os_assets.each do |os_asset|
          asset = Asset.find_by(opensea_id: os_asset['id'])
          holding = Holding.find_or_create_by(asset: asset, wallet: wallet)
        end

        more_assets = false if os_collection_data['next'].blank?

        offset = os_collection_data['next']
      end
    end
  end
end
