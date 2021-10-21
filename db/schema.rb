# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_21_002136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.integer "opensea_id"
    t.string "token_id"
    t.integer "num_sales"
    t.string "background_color"
    t.text "image_url"
    t.text "image_original_url"
    t.text "image_thumbnail_url"
    t.text "animation_url"
    t.text "animation_original_url"
    t.string "name"
    t.text "description"
    t.string "external_link"
    t.string "opensea_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "elo_rating", default: "1600.0"
    t.index ["collection_id"], name: "index_assets_on_collection_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "banner_image_url"
    t.datetime "creation_date", precision: 6
    t.text "description"
    t.text "discord_url"
    t.text "external_url"
    t.text "image_url"
    t.text "large_image_url"
    t.text "short_description"
    t.string "slug"
    t.string "twitter_username"
    t.string "instagram_username"
    t.string "address"
    t.string "schema_name"
    t.string "symbol"
    t.integer "count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip_address"
    t.bigint "winner_id"
    t.bigint "loser_id"
    t.bigint "collection_id"
  end

  add_foreign_key "assets", "collections"
end
