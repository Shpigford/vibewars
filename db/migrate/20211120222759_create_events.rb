class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true
      t.integer :opensea_id
      t.string :auction_type
      t.string :duration
      t.string :ending_price
      t.string :event_type
      t.string :starting_price
      t.string :total_price
      t.string :sale_token
      t.integer :sale_token_decimals

      t.timestamps
    end

    add_index :events, :opensea_id
    add_index :events, :auction_type
  end
end
