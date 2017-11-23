# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171123115400) do

  create_table "battle_records", force: :cascade do |t|
    t.string "unique_key", null: false
    t.string "battle_key", null: false
    t.datetime "battled_at", null: false
    t.string "game_type_key", null: false
    t.text "csa_hands", null: false
    t.text "converted_ki2"
    t.text "converted_kif"
    t.text "converted_csa"
    t.integer "turn_max"
    t.text "kifu_header"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "battle_ships", force: :cascade do |t|
    t.integer "battle_record_id"
    t.integer "battle_user_id"
    t.integer "battle_user_rank_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_record_id"], name: "index_battle_ships_on_battle_record_id"
    t.index ["battle_user_id"], name: "index_battle_ships_on_battle_user_id"
    t.index ["battle_user_rank_id"], name: "index_battle_ships_on_battle_user_rank_id"
  end

  create_table "battle_user_ranks", force: :cascade do |t|
    t.string "unique_key", null: false
    t.integer "priority", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "battle_users", force: :cascade do |t|
    t.string "unique_key", null: false
    t.string "user_key", null: false
    t.integer "battle_user_rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_user_rank_id"], name: "index_battle_users_on_battle_user_rank_id"
  end

  create_table "kifu_convert_infos", force: :cascade do |t|
    t.string "unique_key", null: false
    t.string "kifu_file"
    t.string "kifu_url"
    t.text "kifu_body"
    t.text "converted_ki2"
    t.text "converted_kif"
    t.text "converted_csa"
    t.integer "turn_max"
    t.text "kifu_header"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
