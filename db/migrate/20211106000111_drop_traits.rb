class DropTraits < ActiveRecord::Migration[7.0]
  def change
    drop_table :traits do |t|
      t.references :asset, null: false, foreign_key: true
      t.string :trait_type
      t.string :value
      t.string :display_type
      t.string :max_value
      t.integer :trait_count
      t.integer :order
        
      t.timestamps
    end
  end
end
