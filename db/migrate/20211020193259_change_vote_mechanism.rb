class ChangeVoteMechanism < ActiveRecord::Migration[7.0]
  def change
    remove_column :votes, :asset_id
    add_column :votes, :winner_id, :bigint
    add_column :votes, :loser_id, :bigint
  end
end
