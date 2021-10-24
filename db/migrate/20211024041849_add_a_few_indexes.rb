class AddAFewIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :assets, :elo_rating
    add_index :votes, :collection_id
    add_index :votes, :ip_address
  end
end
