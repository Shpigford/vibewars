class AddSlugIndexToCollections < ActiveRecord::Migration[7.0]
  def change
    add_index :collections, :slug
  end
end
