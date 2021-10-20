class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :banner_image_url
      t.datetime :creation_date
      t.text :description
      t.text :discord_url
      t.text :external_url
      t.text :image_url
      t.text :large_image_url
      t.text :short_description
      t.string :slug
      t.string :twitter_username
      t.string :instagram_username
      t.string :address
      t.string :schema_name
      t.string :symbol
      t.integer :count

      t.timestamps
    end
  end
end
