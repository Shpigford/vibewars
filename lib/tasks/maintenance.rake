namespace :maintenance do
  desc "Update collections"
  task :update_collections => :environment do
    Collection.all.each do |collection|
      BuildCollectionWorker.perform_async(collection.slug)
      
      ProcessCollectionEventsWorker.perform_async(collection.slug, 'created')
      ProcessCollectionEventsWorker.perform_async(collection.slug, 'successful')
      ProcessCollectionEventsWorker.perform_async(collection.slug, 'cancelled')

      UpdateSalesDataWorker.perform_async(collection.slug)
    end

    Wallet.all.each do |wallet|
      ProcessWalletHoldingsWorker.perform_async(wallet.id)
    end
  end

  desc "Update rank"
  task :update_rank => :environment do
    Collection.all.each do |collection|
      UpdateRankWorker.perform_async(collection.id)
    end
  end

  desc "Rebuild progress"
  task :rebuild_progress => :environment do
    Ranking.order(id: :asc).find_each do |ranking|
      progress = ((ranking.votes_count / 30.0) * 100).clamp(0, 100)

      ranking.update(progress: progress)

      puts "#{ranking.id} - #{ranking.votes_count} - #{progress}"
    end
  end

  desc "Fetch all images"
  task :fetch_images => :environment do
    Asset.all.find_each do |asset|
      FetchImageWorker.perform_async(asset.id)
    end
  end

  # desc "Rebuild ratings"
  # task :rebuild_ratings => :environment do
  #   # Reset all ratings
  #   Asset.all.update_all(elo_rating: 1600, votes_count: 0)

  #   Vote.all.find_each do |vote|
  #     votes = Asset.find([vote.winner_id, vote.loser_id])
    
  #     winner = votes.first
  #     loser = votes.last

  #     win_scoring_point = 1
  #     lose_scoring_point = 0

  #     win_probability = 1/(10.0 ** ((loser.elo_rating.to_f - winner.elo_rating.to_f)/400) + 1)
    
  #     winner_new_rating = winner.elo_rating.to_f + (20 * (win_scoring_point - win_probability))
  #     loser_new_rating = loser.elo_rating.to_f + (20 * (lose_scoring_point - win_probability))

  #     winner.update_columns(elo_rating: winner_new_rating, votes_count: winner.votes_count + 1)
  #     loser.update_columns(elo_rating: loser_new_rating, votes_count: winner.votes_count + 1)

  #     puts "#{vote.id} - #{winner_new_rating} - #{loser_new_rating}"
  #   rescue ActiveRecord::RecordNotFound
  #   end
  # end
end