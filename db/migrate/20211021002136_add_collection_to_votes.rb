class AddCollectionToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :collection_id, :bigint
  end
end
