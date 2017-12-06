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

  create_table "battle_ranks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.integer "priority", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_battle_ranks_on_priority"
    t.index ["unique_key"], name: "index_battle_ranks_on_unique_key"
  end

  create_table "battle_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "battle_key", null: false
    t.datetime "battled_at", null: false
    t.string "battle_group_key", null: false
    t.text "csa_seq", null: false
    t.string "battle_state_key", null: false
    t.bigint "win_battle_user_id"
    t.integer "turn_max"
    t.text "kifu_header"
    t.string "sanmyaku_view_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_group_key"], name: "index_battle_records_on_battle_group_key"
    t.index ["battle_key"], name: "index_battle_records_on_battle_key"
    t.index ["battle_state_key"], name: "index_battle_records_on_battle_state_key"
    t.index ["win_battle_user_id"], name: "index_battle_records_on_win_battle_user_id"
  end

  create_table "battle_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "battle_record_id"
    t.bigint "battle_user_id"
    t.bigint "battle_rank_id"
    t.string "win_lose_key", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_rank_id"], name: "index_battle_ships_on_battle_rank_id"
    t.index ["battle_record_id"], name: "index_battle_ships_on_battle_record_id"
    t.index ["battle_user_id"], name: "index_battle_ships_on_battle_user_id"
    t.index ["position"], name: "index_battle_ships_on_position"
    t.index ["win_lose_key"], name: "index_battle_ships_on_win_lose_key"
  end

  create_table "battle_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.string "battle_user_key", null: false
    t.bigint "battle_rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_rank_id"], name: "index_battle_users_on_battle_rank_id"
    t.index ["battle_user_key"], name: "index_battle_users_on_battle_user_key"
    t.index ["unique_key"], name: "index_battle_users_on_unique_key"
  end

  create_table "convert_source_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.string "kifu_file"
    t.string "kifu_url"
    t.text "kifu_body"
    t.integer "turn_max"
    t.text "kifu_header"
    t.string "sanmyaku_view_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_key"], name: "index_convert_source_infos_on_unique_key"
  end

  create_table "converted_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "convertable_type"
    t.bigint "convertable_id"
    t.text "converted_body", null: false
    t.string "converted_format", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convertable_type", "convertable_id"], name: "index_converted_infos_on_convertable_type_and_convertable_id"
    t.index ["converted_format"], name: "index_converted_infos_on_converted_format"
  end

end
