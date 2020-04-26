# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_14_142200) do

  create_table "acns1_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "room_id"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_acns1_messages_on_room_id"
    t.index ["user_id"], name: "index_acns1_messages_on_user_id"
  end

  create_table "acns1_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "acns2_endpos_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "question_id", comment: "問題"
    t.integer "limit_turn", null: false, comment: "N手"
    t.string "sfen_endpos", null: false, comment: "最後の局面"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["limit_turn"], name: "index_acns2_endpos_answers_on_limit_turn"
    t.index ["question_id"], name: "index_acns2_endpos_answers_on_question_id"
  end

  create_table "acns2_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "room_id", comment: "対戦部屋"
    t.bigint "user_id", comment: "対戦者"
    t.string "judge_key", comment: "勝敗"
    t.integer "rensho_count", null: false, comment: "連勝数"
    t.integer "renpai_count", null: false, comment: "連敗数"
    t.integer "quest_index", comment: "解答中の問題"
    t.integer "position", comment: "順序"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["judge_key"], name: "index_acns2_memberships_on_judge_key"
    t.index ["position"], name: "index_acns2_memberships_on_position"
    t.index ["renpai_count"], name: "index_acns2_memberships_on_renpai_count"
    t.index ["rensho_count"], name: "index_acns2_memberships_on_rensho_count"
    t.index ["room_id", "user_id"], name: "index_acns2_memberships_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_acns2_memberships_on_room_id"
    t.index ["user_id"], name: "index_acns2_memberships_on_user_id"
  end

  create_table "acns2_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", comment: "対戦者"
    t.bigint "room_id", comment: "対戦部屋"
    t.string "body", limit: 512, comment: "発言"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_acns2_messages_on_room_id"
    t.index ["user_id"], name: "index_acns2_messages_on_user_id"
  end

  create_table "acns2_moves_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "question_id", comment: "問題"
    t.integer "limit_turn", null: false, comment: "N手"
    t.string "moves_str", null: false, comment: "連続した指し手"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["limit_turn"], name: "index_acns2_moves_answers_on_limit_turn"
    t.index ["question_id"], name: "index_acns2_moves_answers_on_question_id"
  end

  create_table "acns2_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", comment: "対戦者"
    t.integer "rating", null: false, comment: "レーティング"
    t.integer "rating_last_diff", null: false, comment: "直近レーティング変化"
    t.integer "rating_max", null: false, comment: "レーティング(最大)"
    t.integer "rensho_count", null: false, comment: "連勝数"
    t.integer "renpai_count", null: false, comment: "連敗数"
    t.integer "rensho_max", null: false, comment: "連勝数(最大)"
    t.integer "renpai_max", null: false, comment: "連敗数(最大)"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["rating"], name: "index_acns2_profiles_on_rating"
    t.index ["rating_last_diff"], name: "index_acns2_profiles_on_rating_last_diff"
    t.index ["rating_max"], name: "index_acns2_profiles_on_rating_max"
    t.index ["renpai_count"], name: "index_acns2_profiles_on_renpai_count"
    t.index ["renpai_max"], name: "index_acns2_profiles_on_renpai_max"
    t.index ["rensho_count"], name: "index_acns2_profiles_on_rensho_count"
    t.index ["rensho_max"], name: "index_acns2_profiles_on_rensho_max"
    t.index ["user_id"], name: "index_acns2_profiles_on_user_id"
  end

  create_table "acns2_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", comment: "作成者"
    t.string "init_sfen", null: false, comment: "問題"
    t.integer "time_limit_sec", comment: "制限時間(秒)"
    t.integer "difficulty_level", comment: "難易度"
    t.string "title", comment: "タイトル"
    t.string "description", limit: 512, comment: "説明"
    t.string "hint_description", comment: "ヒント"
    t.string "source_desc", comment: "出典"
    t.string "other_twitter_account", comment: "自分以外が作者の場合"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "moves_answers_count", default: 0, null: false, comment: "A解答数"
    t.integer "endpos_answers_count", default: 0, null: false, comment: "B解答数"
    t.integer "o_count", null: false, comment: "正解数"
    t.integer "x_count", null: false, comment: "不正解数"
    t.index ["difficulty_level"], name: "index_acns2_questions_on_difficulty_level"
    t.index ["endpos_answers_count"], name: "index_acns2_questions_on_endpos_answers_count"
    t.index ["init_sfen"], name: "index_acns2_questions_on_init_sfen"
    t.index ["moves_answers_count"], name: "index_acns2_questions_on_moves_answers_count"
    t.index ["o_count"], name: "index_acns2_questions_on_o_count"
    t.index ["time_limit_sec"], name: "index_acns2_questions_on_time_limit_sec"
    t.index ["user_id"], name: "index_acns2_questions_on_user_id"
    t.index ["x_count"], name: "index_acns2_questions_on_x_count"
  end

  create_table "acns2_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "begin_at", null: false, comment: "対戦開始日時"
    t.datetime "end_at", comment: "対戦終了日時"
    t.string "final_key", comment: "結果"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["begin_at"], name: "index_acns2_rooms_on_begin_at"
    t.index ["end_at"], name: "index_acns2_rooms_on_end_at"
    t.index ["final_key"], name: "index_acns2_rooms_on_final_key"
  end

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
    t.text "kifu_body", size: :medium, null: false, comment: "棋譜本文"
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
    t.string "sfen_body", limit: 8192, null: false
    t.integer "image_turn"
    t.string "preset_key", null: false
    t.string "sfen_hash", null: false
    t.index ["battled_at"], name: "index_free_battles_on_battled_at"
    t.index ["colosseum_user_id"], name: "index_free_battles_on_colosseum_user_id"
    t.index ["critical_turn"], name: "index_free_battles_on_critical_turn"
    t.index ["key"], name: "index_free_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_free_battles_on_outbreak_turn"
    t.index ["saturn_key"], name: "index_free_battles_on_saturn_key"
    t.index ["start_turn"], name: "index_free_battles_on_start_turn"
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
    t.string "sfen_body", limit: 8192, null: false
    t.integer "image_turn"
    t.string "sfen_hash", null: false
    t.index ["battled_at"], name: "index_swars_battles_on_battled_at"
    t.index ["critical_turn"], name: "index_swars_battles_on_critical_turn"
    t.index ["final_key"], name: "index_swars_battles_on_final_key"
    t.index ["key"], name: "index_swars_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_swars_battles_on_outbreak_turn"
    t.index ["preset_key"], name: "index_swars_battles_on_preset_key"
    t.index ["rule_key"], name: "index_swars_battles_on_rule_key"
    t.index ["start_turn"], name: "index_swars_battles_on_start_turn"
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
    t.integer "think_max"
    t.bigint "op_user_id", comment: "相手"
    t.integer "think_last"
    t.integer "think_all_avg"
    t.integer "think_end_avg"
    t.integer "two_serial_max"
    t.index ["battle_id", "location_key"], name: "memberships_sbri_lk", unique: true
    t.index ["battle_id", "op_user_id"], name: "memberships_bid_ouid", unique: true
    t.index ["battle_id", "user_id"], name: "memberships_sbri_sbui", unique: true
    t.index ["battle_id"], name: "index_swars_memberships_on_battle_id"
    t.index ["grade_diff"], name: "index_swars_memberships_on_grade_diff"
    t.index ["grade_id"], name: "index_swars_memberships_on_grade_id"
    t.index ["judge_key"], name: "index_swars_memberships_on_judge_key"
    t.index ["location_key"], name: "index_swars_memberships_on_location_key"
    t.index ["op_user_id"], name: "index_swars_memberships_on_op_user_id"
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

  create_table "tsl_leagues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "generation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["generation"], name: "index_tsl_leagues_on_generation"
  end

  create_table "tsl_memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "user_id", null: false
    t.string "result_key", null: false, comment: "結果"
    t.integer "start_pos", null: false, comment: "初期順位"
    t.integer "age"
    t.integer "win"
    t.integer "lose"
    t.string "ox", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["league_id", "user_id"], name: "index_tsl_memberships_on_league_id_and_user_id", unique: true
    t.index ["league_id"], name: "index_tsl_memberships_on_league_id"
    t.index ["lose"], name: "index_tsl_memberships_on_lose"
    t.index ["result_key"], name: "index_tsl_memberships_on_result_key"
    t.index ["start_pos"], name: "index_tsl_memberships_on_start_pos"
    t.index ["user_id"], name: "index_tsl_memberships_on_user_id"
    t.index ["win"], name: "index_tsl_memberships_on_win"
  end

  create_table "tsl_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.integer "first_age", comment: "リーグ入り年齢"
    t.integer "last_age", comment: "リーグ最後の年齢"
    t.integer "memberships_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tsl_users_on_name", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
