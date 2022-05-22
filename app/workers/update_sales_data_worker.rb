class UpdateSalesDataWorker
  include Sidekiq::Worker

  def perform(slug)
    collection = Collection.where(slug: slug).first

    collection.assets.find_each do |asset|
      sale_created = asset.events.where(event_type: 'created').order(created_at: :desc).first

      if sale_created.present?
        sale_ended = asset.events.where(event_type: 'successful').or(asset.events.where(event_type: 'cancelled')).where('events.created_at > ?', sale_created.created_at)

        if sale_ended.present? or (sale_created.created_at + sale_created.duration) > Date.today
          asset.current_sale_price = nil
          asset.current_sale_token = nil
          asset.current_sale_token_decimals = nil
        elsif sale_created.present?
          asset.current_sale_price = sale_created.starting_price
          asset.current_sale_token = sale_created.sale_token
          asset.current_sale_token_decimals = sale_created.sale_token_decimals
        end

        asset.save
      end
    end
  end
end
