class AddProgessToRankings < ActiveRecord::Migration[7.0]
  def change
    add_column :rankings, :progress, :decimal, default: 0
    add_index :rankings, :progress
  end
end
