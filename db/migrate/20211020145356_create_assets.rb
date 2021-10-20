class CreateAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :collection, null: false, foreign_key: true
      t.integer :opensea_id
      t.string :token_id
      t.integer :num_sales
      t.string :background_color
      t.text :image_url
      t.text :image_original_url
      t.text :image_thumbnail_url
      t.text :animation_url
      t.text :animation_original_url
      t.string :name
      t.text :description
      t.string :external_link
      t.string :opensea_link

      t.timestamps
    end
  end
end
