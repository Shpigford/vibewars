class ProcessCollectionEventsWorker
  include Sidekiq::Worker

  def perform(slug, type, occurred_after = nil)
    collection = Collection.where(slug: slug).first

    if occurred_after == nil
      last_event = collection.events.where(event_type: type).order(created_at: :desc).first
      unix_timestamp = last_event.present? ? last_event.created_at.to_i : (Time.now - 1.day).to_i
    else 
      unix_timestamp = occurred_after
    end

    more_events = true
    offset = 0
    
    until more_events === false do
    
      begin
        key = ENV['OPENSEA'].split(',').sample
        puts key

        os_collection = HTTParty.get(
          "https://api.opensea.io/api/v1/events?collection_slug=#{collection.slug}&event_type=#{type}&only_opensea=false&occurred_after=#{unix_timestamp}&offset=#{offset}&limit=300",
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

      if os_collection_data['asset_events'].blank?
        more_events = false
      else
        puts "#{slug} - #{type} - #{occurred_after} - #{offset}"

        os_events = os_collection_data['asset_events']

        os_events.each do |os_event|
          if os_event['asset'].present?
            event = Event.find_or_create_by(opensea_id: os_event['id'])

            event.asset = Asset.find_by(opensea_id: os_event['asset']['id'])
            event.collection = event.asset.collection
            event.auction_type = os_event['auction_type']
            event.duration = os_event['duration']
            event.ending_price = os_event['ending_price']
            event.event_type = os_event['event_type']
            event.starting_price = os_event['starting_price']
            event.total_price = os_event['total_price']
            event.created_at = os_event['created_date'].to_datetime

            if os_event['payment_token'].present?
              event.sale_token = os_event['payment_token']['symbol']
              event.sale_token_decimals = os_event['payment_token']['decimals']
            end

            event.save
          end
        end

        offset += 300
      end
    end

    


  end
end
