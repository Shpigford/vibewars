class AddRankToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :rank, :integer, default: 0
    add_index :assets, :rank
  end
end
