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

ActiveRecord::Schema.define(version: 2020_03_12_105200) do

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

  create_table "alert_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "subject", null: false
    t.string "body", limit: 8192, null: false
    t.datetime "created_at", null: false
  end

  create_table "colosseum_auth_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "provider", null: false
    t.string "uid", null: false
    t.text "meta_info"
    t.index ["provider", "uid"], name: "index_colosseum_auth_infos_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_colosseum_auth_infos_on_user_id"
  end

  create_table "colosseum_battles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "black_preset_key", null: false, comment: "▲手合割"
    t.string "white_preset_key", null: false, comment: "△手合割"
    t.string "lifetime_key", null: false, comment: "時間"
    t.string "team_key", null: false, comment: "人数"
    t.text "full_sfen", null: false, comment: "USI形式棋譜"
    t.text "clock_counts", null: false, comment: "対局時計情報"
    t.text "countdown_flags", null: false, comment: "秒読み状態"
    t.integer "turn_max", null: false, comment: "手番数"
    t.datetime "battle_request_at", comment: "対局申し込みによる成立日時"
    t.datetime "auto_matched_at", comment: "自動マッチングによる成立日時"
    t.datetime "begin_at", comment: "メンバーたち部屋に入って対局開始になった日時"
    t.datetime "end_at", comment: "バトル終了日時"
    t.string "last_action_key", comment: "最後の状態"
    t.string "win_location_key", comment: "勝った方の先後"
    t.integer "memberships_count", default: 0, null: false, comment: "対局者総数"
    t.integer "watch_ships_count", default: 0, null: false, comment: "観戦者数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colosseum_chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.text "message", null: false, comment: "発言"
    t.text "msg_options", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_colosseum_chat_messages_on_battle_id"
    t.index ["user_id"], name: "index_colosseum_chat_messages_on_user_id"
  end

  create_table "colosseum_chronicles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "judge_key", null: false, comment: "結果"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_key"], name: "index_colosseum_chronicles_on_judge_key"
    t.index ["user_id"], name: "index_colosseum_chronicles_on_user_id"
  end

  create_table "colosseum_lobby_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.text "message", null: false, comment: "発言"
    t.text "msg_options", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_colosseum_lobby_messages_on_user_id"
  end

  create_table "colosseum_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "preset_key", null: false, comment: "手合割"
    t.string "location_key", null: false, comment: "先後"
    t.integer "position", comment: "入室順序"
    t.datetime "standby_at", comment: "準備完了日時"
    t.datetime "fighting_at", comment: "部屋に入った日時で抜けたり切断すると空"
    t.datetime "time_up_at", comment: "タイムアップしたのを検知した日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_colosseum_memberships_on_battle_id"
    t.index ["location_key"], name: "index_colosseum_memberships_on_location_key"
    t.index ["position"], name: "index_colosseum_memberships_on_position"
    t.index ["user_id"], name: "index_colosseum_memberships_on_user_id"
  end

  create_table "colosseum_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "begin_greeting_message", null: false, comment: "対局開始時のあいさつ"
    t.string "end_greeting_message", null: false, comment: "対局終了時のあいさつ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_colosseum_profiles_on_user_id", unique: true
  end

  create_table "colosseum_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.string "lifetime_key", null: false, comment: "ルール・持ち時間"
    t.string "team_key", null: false, comment: "ルール・人数"
    t.string "self_preset_key", null: false, comment: "ルール・自分の手合割"
    t.string "oppo_preset_key", null: false, comment: "ルール・相手の手合割"
    t.string "robot_accept_key", null: false, comment: "CPUと対戦するかどうか"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lifetime_key"], name: "index_colosseum_rules_on_lifetime_key"
    t.index ["oppo_preset_key"], name: "index_colosseum_rules_on_oppo_preset_key"
    t.index ["robot_accept_key"], name: "index_colosseum_rules_on_robot_accept_key"
    t.index ["self_preset_key"], name: "index_colosseum_rules_on_self_preset_key"
    t.index ["team_key"], name: "index_colosseum_rules_on_team_key"
    t.index ["user_id"], name: "index_colosseum_rules_on_user_id", unique: true
  end

  create_table "colosseum_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false, comment: "キー"
    t.string "name", null: false, comment: "名前"
    t.datetime "online_at", comment: "オンラインになった日時"
    t.datetime "fighting_at", comment: "memberships.fighting_at と同じでこれを見ると対局中かどうかがすぐにわかる"
    t.datetime "matching_at", comment: "マッチング中(開始日時)"
    t.string "cpu_brain_key", comment: "CPUだったときの挙動"
    t.string "user_agent", null: false, comment: "ブラウザ情報"
    t.string "race_key", null: false, comment: "種族"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "joined_at", comment: "ロビーに入った時間"
    t.index ["confirmation_token"], name: "index_colosseum_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_colosseum_users_on_email", unique: true
    t.index ["key"], name: "index_colosseum_users_on_key", unique: true
    t.index ["race_key"], name: "index_colosseum_users_on_race_key"
    t.index ["reset_password_token"], name: "index_colosseum_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_colosseum_users_on_unlock_token", unique: true
  end

  create_table "colosseum_watch_ships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "部屋"
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battle_id"], name: "index_colosseum_watch_ships_on_battle_id"
    t.index ["user_id"], name: "index_colosseum_watch_ships_on_user_id"
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

  create_table "cpu_battle_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "colosseum_user_id", comment: "ログインしているならそのユーザー"
    t.string "judge_key", null: false, comment: "結果"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colosseum_user_id"], name: "index_cpu_battle_records_on_colosseum_user_id"
    t.index ["judge_key"], name: "index_cpu_battle_records_on_judge_key"
  end

  create_table "free_battles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false, collation: "utf8_bin", comment: "URL識別子"
    t.string "kifu_url", comment: "入力した棋譜URL"
    t.text "kifu_body", limit: 16777215, null: false, comment: "棋譜本文"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.integer "outbreak_turn", comment: "仕掛手数"
    t.string "use_key", null: false
    t.datetime "accessed_at", null: false, comment: "最終参照日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "colosseum_user_id"
    t.string "title"
    t.text "description", null: false
    t.integer "start_turn"
    t.integer "critical_turn"
    t.string "saturn_key", null: false
    t.string "sfen_body", limit: 8192
    t.integer "image_turn"
    t.string "preset_key", null: false
    t.string "sfen_hash"
    t.index ["battled_at"], name: "index_free_battles_on_battled_at"
    t.index ["colosseum_user_id"], name: "index_free_battles_on_colosseum_user_id"
    t.index ["critical_turn"], name: "index_free_battles_on_critical_turn"
    t.index ["key"], name: "index_free_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_free_battles_on_outbreak_turn"
    t.index ["saturn_key"], name: "index_free_battles_on_saturn_key"
    t.index ["turn_max"], name: "index_free_battles_on_turn_max"
    t.index ["use_key"], name: "index_free_battles_on_use_key"
  end

  create_table "swars_battles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false, comment: "対局識別子"
    t.datetime "battled_at", null: false, comment: "対局開始日時"
    t.string "rule_key", null: false, comment: "ルール"
    t.text "csa_seq", null: false, comment: "棋譜の断片"
    t.string "final_key", null: false, comment: "結果詳細"
    t.bigint "win_user_id", comment: "勝者(ショートカット用)"
    t.integer "turn_max", null: false, comment: "手数"
    t.text "meta_info", null: false, comment: "棋譜メタ情報"
    t.datetime "accessed_at", null: false, comment: "最終参照日時"
    t.integer "outbreak_turn", comment: "仕掛手数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "preset_key", null: false
    t.integer "start_turn"
    t.integer "critical_turn"
    t.string "saturn_key", null: false
    t.string "sfen_body", limit: 8192
    t.integer "image_turn"
    t.string "sfen_hash"
    t.index ["battled_at"], name: "index_swars_battles_on_battled_at"
    t.index ["critical_turn"], name: "index_swars_battles_on_critical_turn"
    t.index ["final_key"], name: "index_swars_battles_on_final_key"
    t.index ["key"], name: "index_swars_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_swars_battles_on_outbreak_turn"
    t.index ["rule_key"], name: "index_swars_battles_on_rule_key"
    t.index ["saturn_key"], name: "index_swars_battles_on_saturn_key"
    t.index ["turn_max"], name: "index_swars_battles_on_turn_max"
    t.index ["win_user_id"], name: "index_swars_battles_on_win_user_id"
  end

  create_table "swars_grades", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.integer "priority", null: false, comment: "優劣"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_swars_grades_on_key", unique: true
    t.index ["priority"], name: "index_swars_grades_on_priority"
  end

  create_table "swars_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対局"
    t.bigint "user_id", null: false, comment: "対局者"
    t.bigint "grade_id", null: false, comment: "対局時の段級"
    t.string "judge_key", null: false, comment: "勝・敗・引き分け"
    t.string "location_key", null: false, comment: "▲△"
    t.integer "position", comment: "手番の順序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grade_diff", null: false
    t.index ["battle_id", "location_key"], name: "memberships_sbri_lk", unique: true
    t.index ["battle_id", "user_id"], name: "memberships_sbri_sbui", unique: true
    t.index ["battle_id"], name: "index_swars_memberships_on_battle_id"
    t.index ["grade_diff"], name: "index_swars_memberships_on_grade_diff"
    t.index ["grade_id"], name: "index_swars_memberships_on_grade_id"
    t.index ["judge_key"], name: "index_swars_memberships_on_judge_key"
    t.index ["location_key"], name: "index_swars_memberships_on_location_key"
    t.index ["position"], name: "index_swars_memberships_on_position"
    t.index ["user_id"], name: "index_swars_memberships_on_user_id"
  end

  create_table "swars_search_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "プレイヤー"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_swars_search_logs_on_user_id"
  end

  create_table "swars_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "user_key", null: false, comment: "対局者名"
    t.bigint "grade_id", null: false, comment: "最高段級"
    t.datetime "last_reception_at", comment: "受容日時"
    t.integer "search_logs_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_swars_users_on_grade_id"
    t.index ["last_reception_at"], name: "index_swars_users_on_last_reception_at"
    t.index ["updated_at"], name: "index_swars_users_on_updated_at"
    t.index ["user_key"], name: "index_swars_users_on_user_key", unique: true
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

  create_table "xy_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "colosseum_user_id"
    t.string "entry_name", null: false
    t.string "summary"
    t.string "xy_rule_key", null: false
    t.integer "x_count", null: false
    t.float "spent_sec", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["colosseum_user_id"], name: "index_xy_records_on_colosseum_user_id"
    t.index ["entry_name"], name: "index_xy_records_on_entry_name"
    t.index ["xy_rule_key"], name: "index_xy_records_on_xy_rule_key"
  end

end
