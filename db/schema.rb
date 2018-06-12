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

ActiveRecord::Schema.define(version: 2018_05_27_071050) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "battle_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "black_preset_key", null: false, comment: "▲手合割"
    t.string "white_preset_key", null: false, comment: "△手合割"
    t.string "lifetime_key", null: false, comment: "時間"
    t.string "platoon_key", null: false, comment: "人数"
    t.text "kifu_body_sfen", null: false, comment: "USI形式棋譜"
    t.text "clock_counts", null: false, comment: "対局時計情報"
    t.text "countdown_mode_hash", null: false, comment: "秒読み状態"
    t.integer "turn_max", null: false, comment: "手番数"
    t.datetime "battle_request_at", comment: "対局申し込みによる成立日時"
    t.datetime "auto_matched_at", comment: "自動マッチングによる成立日時"
    t.datetime "begin_at", comment: "メンバーたち部屋に入って対局開始になった日時"
    t.datetime "end_at", comment: "バトル終了日時"
    t.string "last_action_key", comment: "最後の状態"
    t.string "win_location_key", comment: "勝った方の先後"
    t.integer "current_users_count", default: 0, null: false, comment: "この部屋にいる人数"
    t.integer "watch_memberships_count", default: 0, null: false, comment: "この部屋の観戦者数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_room_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.text "message", null: false, comment: "発言"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_room_id"], name: "index_chat_messages_on_battle_room_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "converted_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "convertable_type", null: false
    t.bigint "convertable_id", null: false, comment: "親"
    t.text "text_body", null: false, comment: "棋譜内容"
    t.string "text_format", null: false, comment: "棋譜形式"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convertable_type", "convertable_id"], name: "index_converted_infos_on_convertable_type_and_convertable_id"
    t.index ["text_format"], name: "index_converted_infos_on_text_format"
  end

  create_table "free_battle_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "unique_key", null: false, collation: "utf8_bin", comment: "URL識別子"
    t.string "kifu_file", comment: "アップロードした棋譜ファイル"
    t.string "kifu_url", comment: "入力した棋譜URL"
    t.text "kifu_body", null: false, comment: "棋譜本文"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.string "mountain_url", comment: "将棋山脈の変換後URL"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_key"], name: "index_free_battle_records_on_unique_key", unique: true
  end

  create_table "general_battle_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "battle_key", null: false, comment: "対局識別子"
    t.datetime "battled_at", comment: "対局開始日時"
    t.text "kifu_body", null: false, comment: "棋譜の断片"
    t.string "general_battle_state_key", null: false, comment: "結果詳細"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.string "mountain_url", comment: "将棋山脈の変換後URL"
    t.datetime "last_accessd_at", null: false, comment: "最終参照日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_key"], name: "index_general_battle_records_on_battle_key", unique: true
    t.index ["general_battle_state_key"], name: "index_general_battle_records_on_general_battle_state_key"
  end

  create_table "general_battle_ships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "general_battle_record_id", null: false, comment: "対局"
    t.string "judge_key", null: false, comment: "勝・敗・引き分け"
    t.string "location_key", null: false, comment: "▲△"
    t.integer "position", comment: "手番の順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["general_battle_record_id", "location_key"], name: "general_battle_ships_gbri_lk", unique: true
    t.index ["general_battle_record_id"], name: "index_general_battle_ships_on_general_battle_record_id"
    t.index ["judge_key"], name: "index_general_battle_ships_on_judge_key"
    t.index ["location_key"], name: "index_general_battle_ships_on_location_key"
    t.index ["position"], name: "index_general_battle_ships_on_position"
  end

  create_table "general_battle_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "対局者名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_general_battle_users_on_name", unique: true
  end

  create_table "lobby_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.text "message", null: false, comment: "発言"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lobby_messages_on_user_id"
  end

  create_table "memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_room_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "preset_key", null: false, comment: "手合割"
    t.string "location_key", null: false, comment: "先後"
    t.integer "position", comment: "入室順序"
    t.datetime "standby_at", comment: "準備完了日時"
    t.datetime "fighting_at", comment: "部屋に入った日時で抜けたり切断すると空"
    t.datetime "time_up_trigger_at", comment: "タイムアップしたのを検知した日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_room_id"], name: "index_memberships_on_battle_room_id"
    t.index ["location_key"], name: "index_memberships_on_location_key"
    t.index ["position"], name: "index_memberships_on_position"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "swars_battle_grades", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "unique_key", null: false
    t.integer "priority", null: false, comment: "優劣"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_swars_battle_grades_on_priority"
    t.index ["unique_key"], name: "index_swars_battle_grades_on_unique_key", unique: true
  end

  create_table "swars_battle_record_access_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "swars_battle_record_id", null: false, comment: "対局"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["swars_battle_record_id"], name: "index_swars_battle_record_access_logs_on_swars_battle_record_id"
  end

  create_table "swars_battle_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "battle_key", null: false, comment: "対局識別子"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.string "battle_rule_key", null: false, comment: "ルール"
    t.text "csa_seq", null: false, comment: "棋譜の断片"
    t.string "battle_state_key", null: false, comment: "結果詳細"
    t.bigint "win_swars_battle_user_id", comment: "勝者(ショートカット用)"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.string "mountain_url", comment: "将棋山脈の変換後URL"
    t.datetime "last_accessd_at", null: false, comment: "最終参照日時"
    t.integer "swars_battle_record_access_logs_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_key"], name: "index_swars_battle_records_on_battle_key", unique: true
    t.index ["battle_rule_key"], name: "index_swars_battle_records_on_battle_rule_key"
    t.index ["battle_state_key"], name: "index_swars_battle_records_on_battle_state_key"
    t.index ["win_swars_battle_user_id"], name: "index_swars_battle_records_on_win_swars_battle_user_id"
  end

  create_table "swars_battle_ships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "swars_battle_record_id", null: false, comment: "対局"
    t.bigint "swars_battle_user_id", null: false, comment: "対局者"
    t.bigint "swars_battle_grade_id", null: false, comment: "対局時の段級"
    t.string "judge_key", null: false, comment: "勝・敗・引き分け"
    t.string "location_key", null: false, comment: "▲△"
    t.integer "position", comment: "手番の順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_key"], name: "index_swars_battle_ships_on_judge_key"
    t.index ["location_key"], name: "index_swars_battle_ships_on_location_key"
    t.index ["position"], name: "index_swars_battle_ships_on_position"
    t.index ["swars_battle_grade_id"], name: "index_swars_battle_ships_on_swars_battle_grade_id"
    t.index ["swars_battle_record_id", "location_key"], name: "swars_battle_ships_sbri_lk", unique: true
    t.index ["swars_battle_record_id", "swars_battle_user_id"], name: "swars_battle_ships_sbri_sbui", unique: true
    t.index ["swars_battle_record_id"], name: "index_swars_battle_ships_on_swars_battle_record_id"
    t.index ["swars_battle_user_id"], name: "index_swars_battle_ships_on_swars_battle_user_id"
  end

  create_table "swars_battle_user_receptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "swars_battle_user_id", null: false, comment: "プレイヤー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["swars_battle_user_id"], name: "index_swars_battle_user_receptions_on_swars_battle_user_id"
  end

  create_table "swars_battle_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "user_key", null: false, comment: "対局者名"
    t.bigint "swars_battle_grade_id", null: false, comment: "最高段級"
    t.datetime "last_reception_at", comment: "受容日時"
    t.integer "swars_battle_user_receptions_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["swars_battle_grade_id"], name: "index_swars_battle_users_on_swars_battle_grade_id"
    t.index ["user_key"], name: "index_swars_battle_users_on_user_key", unique: true
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, comment: "名前"
    t.bigint "current_battle_room_id", comment: "現在入室している部屋"
    t.datetime "online_at", comment: "オンラインになった日時"
    t.datetime "fighting_at", comment: "memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる"
    t.datetime "matching_at", comment: "マッチング中(開始日時)"
    t.string "lifetime_key", null: false, comment: "ルール・持ち時間"
    t.string "platoon_key", null: false, comment: "ルール・人数"
    t.string "self_preset_key", null: false, comment: "ルール・自分の手合割"
    t.string "oppo_preset_key", null: false, comment: "ルール・相手の手合割"
    t.string "user_agent", null: false, comment: "ブラウザ情報"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_battle_room_id"], name: "index_users_on_current_battle_room_id"
    t.index ["lifetime_key"], name: "index_users_on_lifetime_key"
    t.index ["oppo_preset_key"], name: "index_users_on_oppo_preset_key"
    t.index ["platoon_key"], name: "index_users_on_platoon_key"
    t.index ["self_preset_key"], name: "index_users_on_self_preset_key"
  end

  create_table "watch_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_room_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_room_id"], name: "index_watch_memberships_on_battle_room_id"
    t.index ["user_id"], name: "index_watch_memberships_on_user_id"
  end

end
