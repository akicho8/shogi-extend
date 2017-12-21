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

ActiveRecord::Schema.define(version: 20171216200205) do

  create_table "battle_grades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false
    t.integer "priority", null: false, comment: "優劣"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_battle_grades_on_priority"
    t.index ["unique_key"], name: "index_battle_grades_on_unique_key", unique: true
  end

  create_table "battle_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "battle_key", null: false, comment: "対局識別子"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.string "battle_rule_key", null: false, comment: "ルール"
    t.text "csa_seq", null: false, comment: "棋譜の断片"
    t.string "battle_state_key", null: false, comment: "結果詳細"
    t.bigint "win_battle_user_id", comment: "勝者(ショートカット用)"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "kifu_header", null: false, comment: "棋譜メタ情報"
    t.string "mountain_url", comment: "将棋山脈の変換後URL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_key"], name: "index_battle_records_on_battle_key", unique: true
    t.index ["battle_rule_key"], name: "index_battle_records_on_battle_rule_key"
    t.index ["battle_state_key"], name: "index_battle_records_on_battle_state_key"
    t.index ["win_battle_user_id"], name: "index_battle_records_on_win_battle_user_id"
  end

  create_table "battle_ships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "battle_record_id", null: false, comment: "対局"
    t.bigint "battle_user_id", null: false, comment: "対局者"
    t.bigint "battle_grade_id", null: false, comment: "対局時の段級"
    t.string "judge_key", null: false, comment: "勝・敗・引き分け"
    t.string "location_key", null: false, comment: "▲△"
    t.integer "position", comment: "手番の順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_grade_id"], name: "index_battle_ships_on_battle_grade_id"
    t.index ["battle_record_id", "battle_user_id"], name: "index_battle_ships_on_battle_record_id_and_battle_user_id", unique: true
    t.index ["battle_record_id", "location_key"], name: "index_battle_ships_on_battle_record_id_and_location_key", unique: true
    t.index ["battle_record_id"], name: "index_battle_ships_on_battle_record_id"
    t.index ["battle_user_id"], name: "index_battle_ships_on_battle_user_id"
    t.index ["judge_key"], name: "index_battle_ships_on_judge_key"
    t.index ["location_key"], name: "index_battle_ships_on_location_key"
    t.index ["position"], name: "index_battle_ships_on_position"
  end

  create_table "battle_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "uid", null: false, comment: "対局者名"
    t.bigint "battle_grade_id", null: false, comment: "最高段級"
    t.datetime "last_reception_at", comment: "受容日時"
    t.integer "user_receptions_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_grade_id"], name: "index_battle_users_on_battle_grade_id"
    t.index ["uid"], name: "index_battle_users_on_uid", unique: true
  end

  create_table "converted_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "convertable_type", null: false
    t.bigint "convertable_id", null: false, comment: "親"
    t.text "text_body", null: false, comment: "棋譜内容"
    t.string "text_format", null: false, comment: "棋譜形式"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convertable_type", "convertable_id"], name: "index_converted_infos_on_convertable_type_and_convertable_id"
    t.index ["text_format"], name: "index_converted_infos_on_text_format"
  end

  create_table "free_battle_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "unique_key", null: false, comment: "URL識別子"
    t.string "kifu_file", comment: "アップロードした棋譜ファイル"
    t.string "kifu_url", comment: "入力した棋譜URL"
    t.text "kifu_body", null: false, comment: "棋譜本文"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "kifu_header", null: false, comment: "棋譜メタ情報"
    t.string "mountain_url", comment: "将棋山脈の変換後URL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_key"], name: "index_free_battle_records_on_unique_key"
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_receptions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "battle_user_id", null: false, comment: "プレイヤー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_user_id"], name: "index_user_receptions_on_battle_user_id"
  end

end
