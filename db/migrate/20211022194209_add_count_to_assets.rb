class AddCountToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :votes_count, :integer, default: 0

    Asset.all.each do |asset|
      winner_count = Vote.where(winner_id: asset.id).count
      loser_count = Vote.where(loser_id: asset.id).count

      asset.update(votes_count: winner_count + loser_count)
    end
  end
end
