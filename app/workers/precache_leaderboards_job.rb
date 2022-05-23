class PrecacheLeaderboardsJob
  include Sidekiq::Worker

  def perform(collection_id = nil)
    if collection_id.present?
      collection = Collection.find(collection_id)

      Rails.cache.write(["v2","query-leaders-#{collection.id}"], collection.votes.where("wallet_id IS NOT NULL OR discord_user_id IS NOT NULL").group(:wallet_id, :discord_user_id).order(count_all: :desc).count.first(100))
    else
      Rails.cache.write(["v2","query-leaders"], Vote.where("wallet_id IS NOT NULL OR discord_user_id IS NOT NULL").group(:wallet_id, :discord_user_id).order(count_all: :desc).count.first(100))
    end
  end
end
