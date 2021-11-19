class FetchImageWorker
  include Sidekiq::Worker

  sidekiq_options queue: :slow, lock: :while_executing, on_conflict: :reject

  def perform(asset_id)
    asset = Asset.find(asset_id)
    image_url = asset.image_url
    image = HTTParty.get("https://res.cloudinary.com/#{ENV['CLOUDINARY']}/image/fetch/#{image_url}")
  end
end
