class AddCountToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :votes_count, :integer, default: 0


  add_index :votes, :winner_id
  add_index :votes, :loser_id

  end
end
