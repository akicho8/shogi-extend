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

  create_table "convert_source_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.string "kifu_file"
    t.string "kifu_url"
    t.text "kifu_body"
    t.integer "turn_max"
    t.text "kifu_header"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "converted_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "convertable_type"
    t.bigint "convertable_id"
    t.text "converted_body", null: false
    t.string "converted_format", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convertable_type", "convertable_id"], name: "index_converted_infos_on_convertable_type_and_convertable_id"
  end

  create_table "war_ranks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.integer "priority", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "war_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.string "battle_key", null: false
    t.datetime "battled_at", null: false
    t.string "game_type_key", null: false
    t.text "csa_hands", null: false
    t.string "reason_key", null: false
    t.bigint "win_war_user_id"
    t.integer "turn_max"
    t.text "kifu_header"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["win_war_user_id"], name: "index_war_records_on_win_war_user_id"
  end

  create_table "war_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "war_record_id"
    t.bigint "war_user_id"
    t.bigint "war_rank_id"
    t.boolean "win_flag", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["war_rank_id"], name: "index_war_ships_on_war_rank_id"
    t.index ["war_record_id"], name: "index_war_ships_on_war_record_id"
    t.index ["war_user_id"], name: "index_war_ships_on_war_user_id"
  end

  create_table "war_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.string "user_key", null: false
    t.bigint "war_rank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["war_rank_id"], name: "index_war_users_on_war_rank_id"
  end

end
