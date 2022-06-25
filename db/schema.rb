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

ActiveRecord::Schema[7.0].define(version: 2022_06_24_021022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "board_players", force: :cascade do |t|
    t.bigint "board_id"
    t.bigint "player_id"
    t.integer "status"
    t.string "score", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_board_players_on_board_id"
    t.index ["player_id"], name: "index_board_players_on_player_id"
  end

  create_table "boards", force: :cascade do |t|
    t.string "token"
    t.integer "status", default: 0
    t.integer "next_first_player_id"
    t.text "deck", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.bigint "round_id"
    t.integer "game_number"
    t.integer "winner_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_games_on_round_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "user_name"
    t.string "password"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "round_players", force: :cascade do |t|
    t.bigint "round_id"
    t.bigint "player_id"
    t.integer "bet_wins"
    t.integer "current_wins", default: 0
    t.integer "bet_position"
    t.text "cards", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_round_players_on_player_id"
    t.index ["round_id"], name: "index_round_players_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "board_id"
    t.integer "number_of_cards"
    t.integer "round_number"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_rounds_on_board_id"
  end

  create_table "turns", force: :cascade do |t|
    t.bigint "round_played_id"
    t.bigint "player_id"
    t.string "card_played", default: ""
    t.integer "player_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_turns_on_player_id"
    t.index ["round_played_id"], name: "index_turns_on_round_played_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
