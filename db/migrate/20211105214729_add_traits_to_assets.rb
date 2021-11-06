class AddTraitsToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :traits, :jsonb, null: false, default: '{}'
    add_index :assets, :traits, using: :gin
  end
end
