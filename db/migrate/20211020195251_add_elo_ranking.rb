class AddEloRanking < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :elo_rating, :decimal, default: 1600.0
  end
end
