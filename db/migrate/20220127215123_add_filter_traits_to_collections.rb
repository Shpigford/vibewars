class AddFilterTraitsToCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :filter_traits, :jsonb, null: false, default: {}
    add_index :collections, :filter_traits, using: :gin
  end
end
