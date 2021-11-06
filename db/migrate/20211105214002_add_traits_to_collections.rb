class AddTraitsToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :traits, :jsonb, null: false, default: '{}'
    add_index :collections, :traits, using: :gin
  end
end
