class AddIndexesToThings < ActiveRecord::Migration[7.0]
  def change
    add_index :collections, :address
    add_index :assets, :opensea_id
  end
end
