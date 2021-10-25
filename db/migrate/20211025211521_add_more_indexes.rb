class AddMoreIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :assets, [:collection_id, :votes_count]
    add_index :assets, [:collection_id, :id]
  end
end
