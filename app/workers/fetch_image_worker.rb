class FetchImageWorker
  include Sidekiq::Worker

  def perform(asset_id)
    asset = Asset.find(asset_id)
    image_url = asset.image_url
    image = HTTParty.get("https://res.cloudinary.com/#{ENV['CLOUDINARY']}/image/fetch/#{image_url}")
  end
end
