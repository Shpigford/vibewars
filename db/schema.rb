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

ActiveRecord::Schema.define(version: 2021_11_19_153711) do

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
    t.integer "votes_count", default: 0
    t.string "current_sale_price"
    t.string "current_sale_token"
    t.integer "current_sale_token_decimals"
    t.integer "rank", default: 0
    t.string "owner_address"
    t.jsonb "traits", default: "{}", null: false
    t.index ["collection_id", "id"], name: "index_assets_on_collection_id_and_id"
    t.index ["collection_id", "votes_count"], name: "index_assets_on_collection_id_and_votes_count"
    t.index ["collection_id"], name: "index_assets_on_collection_id"
    t.index ["elo_rating"], name: "index_assets_on_elo_rating"
    t.index ["opensea_id"], name: "index_assets_on_opensea_id"
    t.index ["owner_address"], name: "index_assets_on_owner_address"
    t.index ["rank"], name: "index_assets_on_rank"
    t.index ["traits"], name: "index_assets_on_traits", using: :gin
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
    t.jsonb "traits", default: "{}", null: false
    t.index ["address"], name: "index_collections_on_address"
    t.index ["slug"], name: "index_collections_on_slug"
    t.index ["traits"], name: "index_collections_on_traits", using: :gin
  end

  create_table "rankings", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "collection_id", null: false
    t.integer "rank", default: 0
    t.decimal "elo_rating", default: "1600.0"
    t.integer "votes_count", default: 0
    t.index ["asset_id"], name: "index_rankings_on_asset_id"
    t.index ["collection_id"], name: "index_rankings_on_collection_id"
    t.index ["elo_rating"], name: "index_rankings_on_elo_rating"
    t.index ["rank"], name: "index_rankings_on_rank"
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ip_address"
    t.bigint "winner_id"
    t.bigint "loser_id"
    t.bigint "collection_id"
    t.bigint "wallet_id"
    t.bigint "discord_server_id"
    t.bigint "discord_user_id"
    t.index ["collection_id"], name: "index_votes_on_collection_id"
    t.index ["discord_server_id"], name: "index_votes_on_discord_server_id"
    t.index ["discord_user_id"], name: "index_votes_on_discord_user_id"
    t.index ["ip_address"], name: "index_votes_on_ip_address"
    t.index ["loser_id"], name: "index_votes_on_loser_id"
    t.index ["wallet_id"], name: "index_votes_on_wallet_id"
    t.index ["winner_id"], name: "index_votes_on_winner_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "address"
    t.string "ens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "opensea_username"
    t.string "opensea_profile_img_url"
  end

  add_foreign_key "assets", "collections"
  add_foreign_key "rankings", "assets"
  add_foreign_key "rankings", "collections"
  add_foreign_key "votes", "wallets"
end
