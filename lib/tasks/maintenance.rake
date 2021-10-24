namespace :maintenance do
  desc "Update collections"
  task :update_collections => :environment do
    Collection.all.each do |collection|
      BuildCollectionWorker.perform_async(collection.address, collection.assets.first.token_id)
    end
  end
end