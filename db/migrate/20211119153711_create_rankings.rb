class CreateRankings < ActiveRecord::Migration[7.0]
  def change
    create_table :rankings do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true
      t.integer :rank, default: 0
      t.decimal :elo_rating, default: "1600.0"
      t.integer :votes_count, default: 0
    end

    add_index :rankings, :elo_rating
    add_index :rankings, :rank
  end
end
