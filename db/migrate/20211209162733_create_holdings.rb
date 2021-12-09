class CreateHoldings < ActiveRecord::Migration[7.0]
  def change
    create_table :holdings do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true
      t.timestamps
    end
  end
end
