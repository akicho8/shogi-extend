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

ActiveRecord::Schema[8.1].define(version: 2025_10_23_000002) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata", size: :medium
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "aggregate_caches", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.json "aggregated_value", null: false, comment: "集計済みデータ"
    t.datetime "created_at", null: false
    t.integer "generation", null: false, comment: "世代"
    t.string "group_name", null: false, comment: "スコープ"
    t.datetime "updated_at", null: false
    t.index ["generation"], name: "index_aggregate_caches_on_generation"
    t.index ["group_name", "generation"], name: "index_aggregate_caches_on_group_name_and_generation", unique: true
    t.index ["group_name"], name: "index_aggregate_caches_on_group_name"
  end

  create_table "app_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "emoji", null: false
    t.string "level", null: false
    t.integer "process_id", null: false
    t.string "subject", null: false
    t.index ["created_at"], name: "index_app_logs_on_created_at"
  end

  create_table "auth_infos", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.text "meta_info", comment: "JSON形式での保存用"
    t.string "provider", null: false
    t.string "uid", null: false
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.index ["provider", "uid"], name: "index_auth_infos_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_auth_infos_on_user_id"
  end

  create_table "cpu_battle_records", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "judge_key", null: false, comment: "結果"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["judge_key"], name: "index_cpu_battle_records_on_judge_key"
    t.index ["user_id"], name: "index_cpu_battle_records_on_user_id"
  end

  create_table "free_battles", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "accessed_at", precision: nil, null: false
    t.datetime "battled_at", precision: nil, null: false, comment: "対局開始日時"
    t.datetime "created_at", precision: nil, null: false
    t.integer "critical_turn"
    t.text "description", null: false
    t.integer "image_turn"
    t.string "key", null: false, comment: "URL識別子"
    t.text "kifu_body"
    t.text "meta_info", size: :medium, null: false, comment: "棋譜メタ情報"
    t.integer "outbreak_turn"
    t.bigint "preset_id", comment: "手合割"
    t.string "saturn_key", null: false
    t.text "sfen_body", null: false
    t.string "sfen_hash", null: false
    t.integer "start_turn"
    t.string "title"
    t.integer "turn_max", null: false, comment: "手数"
    t.datetime "updated_at", precision: nil, null: false
    t.string "use_key", null: false
    t.bigint "user_id"
    t.index ["accessed_at"], name: "index_free_battles_on_accessed_at"
    t.index ["battled_at"], name: "index_free_battles_on_battled_at"
    t.index ["critical_turn"], name: "index_free_battles_on_critical_turn"
    t.index ["key"], name: "index_free_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_free_battles_on_outbreak_turn"
    t.index ["preset_id"], name: "index_free_battles_on_preset_id"
    t.index ["saturn_key"], name: "index_free_battles_on_saturn_key"
    t.index ["turn_max"], name: "index_free_battles_on_turn_max"
    t.index ["use_key"], name: "index_free_battles_on_use_key"
    t.index ["user_id"], name: "index_free_battles_on_user_id"
  end

  create_table "google_api_expiration_trackers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "spreadsheet_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "google_api_sheet_expiration_trackers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "spreadsheet_id", null: false
    t.datetime "updated_at", null: false
  end

  create_table "holidays", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.date "holiday_on", null: false, comment: "祝日"
    t.string "name", null: false
    t.index ["holiday_on"], name: "index_holidays_on_holiday_on", unique: true
  end

  create_table "judges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_judges_on_key", unique: true
    t.index ["position"], name: "index_judges_on_position"
  end

  create_table "kiwi_access_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "banana_id", null: false, comment: "動画"
    t.datetime "created_at", precision: nil, null: false, comment: "記録日時"
    t.bigint "user_id", comment: "参照者"
    t.index ["banana_id"], name: "index_kiwi_access_logs_on_banana_id"
    t.index ["user_id"], name: "index_kiwi_access_logs_on_user_id"
  end

  create_table "kiwi_banana_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "banana_id", null: false, comment: "動画"
    t.string "body", limit: 512, null: false, comment: "発言"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil, comment: "削除日時"
    t.integer "position", null: false, comment: "番号"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "発言者"
    t.index ["banana_id", "position"], name: "index_kiwi_banana_messages_on_banana_id_and_position", unique: true
    t.index ["banana_id"], name: "index_kiwi_banana_messages_on_banana_id"
    t.index ["position"], name: "index_kiwi_banana_messages_on_position"
    t.index ["user_id"], name: "index_kiwi_banana_messages_on_user_id"
  end

  create_table "kiwi_bananas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "access_logs_count", default: 0, null: false, comment: "総アクセス数"
    t.integer "banana_messages_count", default: 0, null: false, comment: "コメント数"
    t.datetime "created_at", null: false
    t.text "description", null: false, comment: "説明"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "key", null: false
    t.bigint "lemon_id", null: false, comment: "動画"
    t.float "thumbnail_pos", null: false, comment: "サムネ位置"
    t.string "title", limit: 100, null: false, comment: "タイトル"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.index ["access_logs_count"], name: "index_kiwi_bananas_on_access_logs_count"
    t.index ["banana_messages_count"], name: "index_kiwi_bananas_on_banana_messages_count"
    t.index ["folder_id"], name: "index_kiwi_bananas_on_folder_id"
    t.index ["key"], name: "index_kiwi_bananas_on_key", unique: true
    t.index ["lemon_id"], name: "index_kiwi_bananas_on_lemon_id", unique: true
    t.index ["user_id"], name: "index_kiwi_bananas_on_user_id"
  end

  create_table "kiwi_book_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "body", limit: 512, null: false, comment: "発言"
    t.bigint "book_id", null: false, comment: "動画"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil, comment: "削除日時"
    t.integer "position", null: false, comment: "番号"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "発言者"
    t.index ["book_id", "position"], name: "index_kiwi_book_messages_on_book_id_and_position", unique: true
    t.index ["book_id"], name: "index_kiwi_book_messages_on_book_id"
    t.index ["position"], name: "index_kiwi_book_messages_on_position"
    t.index ["user_id"], name: "index_kiwi_book_messages_on_user_id"
  end

  create_table "kiwi_books", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "access_logs_count", default: 0, null: false, comment: "総アクセス数"
    t.integer "book_messages_count", default: 0, null: false, comment: "コメント数"
    t.datetime "created_at", null: false
    t.text "description", null: false, comment: "説明"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "key", null: false
    t.bigint "lemon_id", null: false, comment: "動画"
    t.float "thumbnail_pos", null: false, comment: "サムネ位置"
    t.string "title", limit: 100, null: false, comment: "タイトル"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.index ["access_logs_count"], name: "index_kiwi_books_on_access_logs_count"
    t.index ["book_messages_count"], name: "index_kiwi_books_on_book_messages_count"
    t.index ["folder_id"], name: "index_kiwi_books_on_folder_id"
    t.index ["key"], name: "index_kiwi_books_on_key", unique: true
    t.index ["lemon_id"], name: "index_kiwi_books_on_lemon_id", unique: true
    t.index ["user_id"], name: "index_kiwi_books_on_user_id"
  end

  create_table "kiwi_folders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "bananas_count", default: 0, null: false, comment: "問題集数"
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_kiwi_folders_on_key", unique: true
    t.index ["position"], name: "index_kiwi_folders_on_position"
  end

  create_table "kiwi_lemons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "all_params", null: false, comment: "変換パラメータ全部入り"
    t.string "browser_path", comment: "生成したファイルへのパス"
    t.string "content_type", comment: "コンテンツタイプ"
    t.datetime "created_at", null: false
    t.text "error_message", comment: "エラーメッセージ"
    t.datetime "errored_at", precision: nil, comment: "エラー日時"
    t.text "ffprobe_info", comment: "変換パラメータ"
    t.integer "file_size", comment: "ファイルサイズ"
    t.string "filename_human", comment: "ダウンロードファイル名"
    t.datetime "process_begin_at", precision: nil, comment: "処理開始日時"
    t.datetime "process_end_at", precision: nil, comment: "処理終了日時"
    t.bigint "recordable_id", null: false, comment: "対象レコード"
    t.string "recordable_type", null: false
    t.datetime "successed_at", precision: nil, comment: "成功日時"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "所有者"
    t.index ["created_at"], name: "index_kiwi_lemons_on_created_at"
    t.index ["errored_at"], name: "index_kiwi_lemons_on_errored_at"
    t.index ["process_begin_at"], name: "index_kiwi_lemons_on_process_begin_at"
    t.index ["process_end_at"], name: "index_kiwi_lemons_on_process_end_at"
    t.index ["recordable_type", "recordable_id"], name: "index_kiwi_lemons_on_recordable_type_and_recordable_id"
    t.index ["successed_at"], name: "index_kiwi_lemons_on_successed_at"
    t.index ["user_id"], name: "index_kiwi_lemons_on_user_id"
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_locations_on_key", unique: true
    t.index ["position"], name: "index_locations_on_position"
  end

  create_table "maintenance_tasks_runs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "arguments"
    t.text "backtrace"
    t.datetime "created_at", null: false
    t.string "cursor"
    t.datetime "ended_at", precision: nil
    t.string "error_class"
    t.string "error_message"
    t.string "job_id"
    t.integer "lock_version", default: 0, null: false
    t.text "metadata"
    t.datetime "started_at", precision: nil
    t.string "status", default: "enqueued", null: false
    t.string "task_name", null: false
    t.bigint "tick_count", default: 0, null: false
    t.bigint "tick_total"
    t.float "time_running", default: 0.0, null: false
    t.datetime "updated_at", null: false
    t.index ["task_name", "status", "created_at"], name: "index_maintenance_tasks_runs", order: { created_at: :desc }
  end

  create_table "permanent_variables", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false, comment: "キー"
    t.datetime "updated_at", null: false
    t.json "value", comment: "値"
    t.index ["key"], name: "index_permanent_variables_on_key", unique: true
  end

  create_table "ppl_league_seasons", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false, comment: "キー (表示名)"
    t.integer "position", comment: "順序"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_ppl_league_seasons_on_key"
    t.index ["position"], name: "index_ppl_league_seasons_on_position"
  end

  create_table "ppl_leagues", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "generation", null: false, comment: "期"
    t.datetime "updated_at", null: false
    t.index ["generation"], name: "index_ppl_leagues_on_generation"
  end

  create_table "ppl_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "age", null: false, comment: "年齢"
    t.datetime "created_at", null: false
    t.integer "lose", comment: "負け数"
    t.string "ox", null: false, comment: "勝敗"
    t.integer "ranking_pos", comment: "最終順位"
    t.bigint "result_id", null: false, comment: "結果"
    t.bigint "season_id", null: false, comment: "リーグ"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "棋士"
    t.integer "win", comment: "勝ち数"
    t.index ["result_id"], name: "index_ppl_memberships_on_result_id"
    t.index ["season_id", "user_id"], name: "index_ppl_memberships_on_season_id_and_user_id", unique: true
    t.index ["season_id"], name: "index_ppl_memberships_on_season_id"
    t.index ["user_id"], name: "index_ppl_memberships_on_user_id"
    t.index ["win"], name: "index_ppl_memberships_on_win"
  end

  create_table "ppl_mentors", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false, comment: "師匠名"
    t.datetime "updated_at", null: false
    t.integer "users_count", default: 0, null: false, comment: "弟子数"
    t.index ["name"], name: "index_ppl_mentors_on_name", unique: true
  end

  create_table "ppl_ranks", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_ppl_ranks_on_key", unique: true
    t.index ["position"], name: "index_ppl_ranks_on_position"
  end

  create_table "ppl_results", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_ppl_results_on_key", unique: true
    t.index ["position"], name: "index_ppl_results_on_position"
  end

  create_table "ppl_seasons", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false, comment: "キー (表示名)"
    t.integer "position", comment: "順序"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_ppl_seasons_on_key"
    t.index ["position"], name: "index_ppl_seasons_on_position"
  end

  create_table "ppl_users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "age_max", null: false, comment: "リーグ最後の年齢"
    t.integer "age_min", null: false, comment: "リーグ入り年齢"
    t.datetime "created_at", null: false
    t.bigint "deactivated_membership_id", comment: "退会時したときの成績"
    t.integer "memberships_count", default: 0, null: false, comment: "参加期間相当"
    t.bigint "memberships_first_id", comment: "最初に参加したときの成績"
    t.bigint "memberships_last_id", comment: "最後に参加したときの成績"
    t.bigint "mentor_id", comment: "師匠"
    t.string "name", null: false, comment: "棋士名"
    t.bigint "promotion_membership_id", comment: "プロになったときの成績"
    t.integer "promotion_season_position", comment: "プロになったときのシーズンの順序"
    t.integer "promotion_win", comment: "プロになったときの勝ち数"
    t.bigint "rank_id", null: false, comment: "種類"
    t.integer "runner_up_count", comment: "次点個数"
    t.datetime "updated_at", null: false
    t.integer "win_max", comment: "最大勝ち数"
    t.float "win_ratio", comment: "勝率"
    t.index ["age_max"], name: "index_ppl_users_on_age_max"
    t.index ["age_min"], name: "index_ppl_users_on_age_min"
    t.index ["deactivated_membership_id"], name: "index_ppl_users_on_deactivated_membership_id"
    t.index ["memberships_first_id"], name: "index_ppl_users_on_memberships_first_id"
    t.index ["memberships_last_id"], name: "index_ppl_users_on_memberships_last_id"
    t.index ["mentor_id"], name: "index_ppl_users_on_mentor_id"
    t.index ["name"], name: "index_ppl_users_on_name", unique: true
    t.index ["promotion_membership_id"], name: "index_ppl_users_on_promotion_membership_id"
    t.index ["promotion_season_position"], name: "index_ppl_users_on_promotion_season_position"
    t.index ["promotion_win"], name: "index_ppl_users_on_promotion_win"
    t.index ["rank_id"], name: "index_ppl_users_on_rank_id"
    t.index ["win_max"], name: "index_ppl_users_on_win_max"
    t.index ["win_ratio"], name: "index_ppl_users_on_win_ratio"
  end

  create_table "presets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_presets_on_key", unique: true
    t.index ["position"], name: "index_presets_on_position"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "ユーザー"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "share_board_battles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false, comment: "対局識別子"
    t.integer "position", comment: "順序"
    t.bigint "room_id", null: false, comment: "部屋"
    t.text "sfen", null: false
    t.string "title", null: false, comment: "タイトル"
    t.integer "turn", null: false, comment: "手数"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "win_location_id", null: false, comment: "勝利側"
    t.index ["key"], name: "index_share_board_battles_on_key", unique: true
    t.index ["position"], name: "index_share_board_battles_on_position"
    t.index ["room_id"], name: "index_share_board_battles_on_room_id"
    t.index ["turn"], name: "index_share_board_battles_on_turn"
    t.index ["win_location_id"], name: "index_share_board_battles_on_win_location_id"
  end

  create_table "share_board_chat_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "client_token", null: false, comment: "クライアント固有の識別子"
    t.string "content", limit: 256, null: false, comment: "発言内容"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "force_talk", null: false, comment: "ONなら必ず発声する"
    t.string "from_connection_id", comment: "null なら bot 等"
    t.bigint "message_scope_id", null: false, comment: "スコープ"
    t.bigint "performed_at", null: false, comment: "実行開始日時(ms)"
    t.string "primary_emoji", comment: "優先する絵文字"
    t.bigint "room_id", null: false, comment: "部屋"
    t.bigint "session_user_id", comment: "ログインユーザー"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "発言者(キーは名前だけなのですり変われる)"
    t.string "user_selected_avatar", null: false, comment: "アバター(1文字の絵文字)"
    t.index ["message_scope_id"], name: "index_share_board_chat_messages_on_message_scope_id"
    t.index ["room_id"], name: "index_share_board_chat_messages_on_room_id"
    t.index ["session_user_id"], name: "index_share_board_chat_messages_on_session_user_id"
    t.index ["user_id"], name: "index_share_board_chat_messages_on_user_id"
  end

  create_table "share_board_memberships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "battle_id", null: false, comment: "対局"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "judge_id", null: false, comment: "勝・敗・引き分け"
    t.bigint "location_id", null: false, comment: "▲△"
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "対局者"
    t.index ["battle_id"], name: "index_share_board_memberships_on_battle_id"
    t.index ["judge_id"], name: "index_share_board_memberships_on_judge_id"
    t.index ["location_id"], name: "index_share_board_memberships_on_location_id"
    t.index ["position"], name: "index_share_board_memberships_on_position"
    t.index ["user_id"], name: "index_share_board_memberships_on_user_id"
  end

  create_table "share_board_message_scopes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_share_board_message_scopes_on_key", unique: true
    t.index ["position"], name: "index_share_board_message_scopes_on_position"
  end

  create_table "share_board_rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "battles_count", default: 0
    t.integer "chat_messages_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false, comment: "部屋識別子"
    t.string "name", null: false, comment: "部屋名"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_share_board_rooms_on_key", unique: true
  end

  create_table "share_board_roomships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "battles_count", null: false, comment: "対局数"
    t.datetime "created_at", precision: nil, null: false
    t.integer "lose_count", null: false, comment: "負数"
    t.integer "rank", null: false, comment: "順位"
    t.bigint "room_id", null: false, comment: "部屋"
    t.integer "score", null: false, comment: "スコア"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "対局者"
    t.integer "win_count", null: false, comment: "勝数"
    t.float "win_rate", null: false, comment: "勝率"
    t.index ["lose_count"], name: "index_share_board_roomships_on_lose_count"
    t.index ["rank"], name: "index_share_board_roomships_on_rank"
    t.index ["room_id"], name: "index_share_board_roomships_on_room_id"
    t.index ["score"], name: "index_share_board_roomships_on_score"
    t.index ["user_id"], name: "index_share_board_roomships_on_user_id"
    t.index ["win_count"], name: "index_share_board_roomships_on_win_count"
    t.index ["win_rate"], name: "index_share_board_roomships_on_win_rate"
  end

  create_table "share_board_users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "chat_messages_count", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.integer "memberships_count", default: 0
    t.string "name", null: false, comment: "対局者名"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_share_board_users_on_name", unique: true
  end

  create_table "short_url_access_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "component_id", comment: "コンポーネント"
    t.datetime "created_at", precision: nil, null: false, comment: "記録日時"
    t.index ["component_id"], name: "index_short_url_access_logs_on_component_id"
  end

  create_table "short_url_components", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "access_logs_count", default: 0, null: false, comment: "総アクセス数"
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false, comment: "ハッシュ"
    t.string "original_url", limit: 2048, null: false, comment: "元URL"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_short_url_components_on_key", unique: true
  end

  create_table "swars_ban_crawl_requests", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "BAN判定対象者"
    t.index ["user_id"], name: "index_swars_ban_crawl_requests_on_user_id"
  end

  create_table "swars_battles", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "accessed_at", precision: nil, null: false
    t.integer "analysis_version", default: 0, null: false, comment: "戦法解析バージョン"
    t.datetime "battled_at", precision: nil, null: false, comment: "対局開始日時"
    t.datetime "created_at", precision: nil, null: false
    t.integer "critical_turn"
    t.text "csa_seq", size: :medium, null: false, comment: "棋譜の断片"
    t.bigint "final_id", null: false, comment: "結末"
    t.integer "image_turn"
    t.bigint "imode_id", null: false, comment: "開始モード"
    t.string "key", null: false, comment: "対局識別子"
    t.text "meta_info", size: :medium, null: false, comment: "棋譜メタ情報"
    t.integer "outbreak_turn"
    t.bigint "preset_id", null: false, comment: "手合割"
    t.bigint "rule_id", null: false, comment: "持ち時間"
    t.text "sfen_body", null: false
    t.string "sfen_hash"
    t.integer "start_turn"
    t.string "starting_position", comment: "初期配置"
    t.integer "turn_max", null: false, comment: "手数"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "win_user_id", comment: "勝者(ショートカット用)"
    t.bigint "xmode_id", null: false, comment: "対局モード"
    t.index ["accessed_at"], name: "index_swars_battles_on_accessed_at"
    t.index ["battled_at"], name: "index_swars_battles_on_battled_at"
    t.index ["created_at"], name: "index_swars_battles_on_created_at"
    t.index ["critical_turn"], name: "index_swars_battles_on_critical_turn"
    t.index ["final_id"], name: "index_swars_battles_on_final_id"
    t.index ["imode_id"], name: "index_swars_battles_on_imode_id"
    t.index ["key"], name: "index_swars_battles_on_key", unique: true
    t.index ["outbreak_turn"], name: "index_swars_battles_on_outbreak_turn"
    t.index ["preset_id"], name: "index_swars_battles_on_preset_id"
    t.index ["rule_id"], name: "index_swars_battles_on_rule_id"
    t.index ["turn_max"], name: "index_swars_battles_on_turn_max"
    t.index ["win_user_id"], name: "index_swars_battles_on_win_user_id"
    t.index ["xmode_id"], name: "index_swars_battles_on_xmode_id"
  end

  create_table "swars_crawl_reservations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "attachment_mode", null: false, comment: "ZIPファイル添付の有無"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "processed_at", precision: nil, comment: "処理完了日時"
    t.string "target_user_key", null: false, comment: "対象者"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "登録者"
    t.index ["attachment_mode"], name: "index_swars_crawl_reservations_on_attachment_mode"
    t.index ["user_id"], name: "index_swars_crawl_reservations_on_user_id"
  end

  create_table "swars_finals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_finals_on_key", unique: true
    t.index ["position"], name: "index_swars_finals_on_position"
  end

  create_table "swars_grades", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "priority", null: false, comment: "優劣"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_grades_on_key", unique: true
    t.index ["priority"], name: "index_swars_grades_on_priority"
  end

  create_table "swars_imodes", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_imodes_on_key", unique: true
    t.index ["position"], name: "index_swars_imodes_on_position"
  end

  create_table "swars_membership_extras", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "membership_id", null: false, comment: "対局情報"
    t.datetime "updated_at", null: false
    t.json "used_piece_counts", null: false, comment: "駒の使用頻度"
    t.index ["membership_id"], name: "index_swars_membership_extras_on_membership_id", unique: true
  end

  create_table "swars_memberships", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "ai_drop_total", comment: "棋神を使って指した総手数"
    t.float "ai_gear_freq", comment: "121頻出度"
    t.integer "ai_noizy_two_max", comment: "22221パターンを考慮した2の並び個数最大値"
    t.float "ai_two_freq", comment: "2手差し頻出度"
    t.integer "ai_wave_count", comment: "棋神使用模様個数"
    t.bigint "battle_id", null: false, comment: "対局"
    t.datetime "created_at", precision: nil, null: false
    t.integer "ek_score_with_cond", comment: "入玉宣言時の得点(条件考慮)"
    t.integer "ek_score_without_cond", comment: "入玉宣言時の得点(仮)"
    t.integer "grade_diff", null: false
    t.bigint "grade_id", null: false, comment: "対局時の段級"
    t.bigint "judge_id", null: false, comment: "勝敗"
    t.bigint "location_id", null: false, comment: "位置"
    t.bigint "op_user_id", comment: "相手"
    t.bigint "opponent_id", comment: "相手レコード"
    t.integer "position", comment: "手番の順序"
    t.bigint "style_id", comment: "棋風"
    t.integer "think_all_avg"
    t.integer "think_end_avg"
    t.integer "think_last"
    t.integer "think_max"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "対局者"
    t.index ["battle_id", "location_id"], name: "memberships_sbri_lk", unique: true
    t.index ["battle_id", "op_user_id"], name: "memberships_bid_ouid", unique: true
    t.index ["battle_id", "user_id"], name: "memberships_sbri_sbui", unique: true
    t.index ["battle_id"], name: "index_swars_memberships_on_battle_id"
    t.index ["grade_diff"], name: "index_swars_memberships_on_grade_diff"
    t.index ["grade_id"], name: "index_swars_memberships_on_grade_id"
    t.index ["judge_id"], name: "index_swars_memberships_on_judge_id"
    t.index ["location_id"], name: "index_swars_memberships_on_location_id"
    t.index ["op_user_id"], name: "index_swars_memberships_on_op_user_id"
    t.index ["opponent_id"], name: "index_swars_memberships_on_opponent_id", unique: true
    t.index ["position"], name: "index_swars_memberships_on_position"
    t.index ["style_id"], name: "index_swars_memberships_on_style_id"
    t.index ["user_id"], name: "index_swars_memberships_on_user_id"
  end

  create_table "swars_profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "ban_at", precision: nil, comment: "垢BAN日時"
    t.datetime "ban_crawled_at", precision: nil, null: false, comment: "垢BANクロール日時"
    t.integer "ban_crawled_count", comment: "垢BANクロール回数"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "対局者"
    t.index ["ban_at"], name: "index_swars_profiles_on_ban_at"
    t.index ["user_id"], name: "index_swars_profiles_on_user_id"
  end

  create_table "swars_rules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_rules_on_key", unique: true
    t.index ["position"], name: "index_swars_rules_on_position"
  end

  create_table "swars_search_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false, comment: "プレイヤー"
    t.index ["user_id"], name: "index_swars_search_logs_on_user_id"
  end

  create_table "swars_styles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_styles_on_key", unique: true
    t.index ["position"], name: "index_swars_styles_on_position"
  end

  create_table "swars_users", charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.datetime "ban_at", precision: nil, comment: "垢BAN日時"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "grade_id", null: false, comment: "最高段級"
    t.datetime "hard_crawled_at", precision: nil, comment: "クロール(1ページ目のみ)"
    t.datetime "last_reception_at", precision: nil, comment: "受容日時"
    t.datetime "latest_battled_at", precision: nil, null: false, comment: "直近の対局日時"
    t.integer "search_logs_count", default: 0
    t.datetime "soft_crawled_at", precision: nil, comment: "クロール(全体)"
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_key", null: false, comment: "対局者名"
    t.index ["ban_at"], name: "index_swars_users_on_ban_at"
    t.index ["grade_id"], name: "index_swars_users_on_grade_id"
    t.index ["last_reception_at"], name: "index_swars_users_on_last_reception_at"
    t.index ["updated_at"], name: "index_swars_users_on_updated_at"
    t.index ["user_key"], name: "index_swars_users_on_user_key", unique: true
  end

  create_table "swars_xmodes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["key"], name: "index_swars_xmodes_on_key", unique: true
    t.index ["position"], name: "index_swars_xmodes_on_position"
  end

  create_table "swars_zip_dl_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "begin_at", precision: nil, null: false, comment: "スコープ(開始・記録用)"
    t.datetime "created_at", null: false
    t.integer "dl_count", null: false, comment: "ダウンロード数(記録用)"
    t.datetime "end_at", precision: nil, null: false, comment: "スコープ(終了)"
    t.string "query", null: false, comment: "クエリ全体(予備)"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "登録者"
    t.index ["created_at"], name: "index_swars_zip_dl_logs_on_created_at"
    t.index ["end_at"], name: "index_swars_zip_dl_logs_on_end_at"
    t.index ["user_id"], name: "index_swars_zip_dl_logs_on_user_id"
  end

  create_table "taggings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
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

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", options: "ENGINE=InnoDB ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tsl_results", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", comment: "順序"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_tsl_results_on_key", unique: true
    t.index ["position"], name: "index_tsl_results_on_position"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "key", null: false, comment: "キー"
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.string "name", null: false, comment: "名前"
    t.datetime "name_input_at", precision: nil
    t.string "race_key", null: false, comment: "種族"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["key"], name: "index_users_on_key", unique: true
    t.index ["race_key"], name: "index_users_on_race_key"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "wkbk_access_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "book_id", null: false, comment: "問題集"
    t.datetime "created_at", precision: nil, null: false, comment: "記録日時"
    t.bigint "user_id", comment: "参照者"
    t.index ["book_id"], name: "index_wkbk_access_logs_on_book_id"
    t.index ["user_id"], name: "index_wkbk_access_logs_on_user_id"
  end

  create_table "wkbk_answer_kinds", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_wkbk_answer_kinds_on_key", unique: true
    t.index ["position"], name: "index_wkbk_answer_kinds_on_position"
  end

  create_table "wkbk_answer_logs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "answer_kind_id", null: false, comment: "解答"
    t.bigint "article_id", null: false, comment: "出題"
    t.bigint "book_id", null: false, comment: "対戦部屋"
    t.datetime "created_at", precision: nil, null: false
    t.integer "spent_sec", null: false, comment: "使用時間"
    t.bigint "user_id", null: false, comment: "自分"
    t.index ["answer_kind_id"], name: "index_wkbk_answer_logs_on_answer_kind_id"
    t.index ["article_id"], name: "index_wkbk_answer_logs_on_article_id"
    t.index ["book_id"], name: "index_wkbk_answer_logs_on_book_id"
    t.index ["created_at"], name: "index_wkbk_answer_logs_on_created_at"
    t.index ["spent_sec"], name: "index_wkbk_answer_logs_on_spent_sec"
    t.index ["user_id"], name: "index_wkbk_answer_logs_on_user_id"
  end

  create_table "wkbk_articles", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "answer_logs_count", default: 0, null: false, comment: "解答数"
    t.datetime "created_at", null: false
    t.text "description", null: false, comment: "説明"
    t.integer "difficulty", null: false, comment: "難易度"
    t.string "direction_message", limit: 100, null: false, comment: "メッセージ"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "init_sfen", null: false, comment: "問題"
    t.string "key", null: false
    t.bigint "lineage_id", null: false, comment: "種類"
    t.boolean "mate_skip", null: false, comment: "詰みチェックをスキップする"
    t.integer "moves_answers_count", default: 0, null: false, comment: "解答数"
    t.string "title", limit: 100, null: false, comment: "タイトル"
    t.integer "turn_max", null: false, comment: "最大手数"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.string "viewpoint", null: false, comment: "視点"
    t.index ["difficulty"], name: "index_wkbk_articles_on_difficulty"
    t.index ["folder_id"], name: "index_wkbk_articles_on_folder_id"
    t.index ["init_sfen"], name: "index_wkbk_articles_on_init_sfen"
    t.index ["key"], name: "index_wkbk_articles_on_key", unique: true
    t.index ["lineage_id"], name: "index_wkbk_articles_on_lineage_id"
    t.index ["turn_max"], name: "index_wkbk_articles_on_turn_max"
    t.index ["user_id"], name: "index_wkbk_articles_on_user_id"
  end

  create_table "wkbk_books", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "access_logs_count", default: 0, null: false, comment: "総アクセス数"
    t.integer "answer_logs_count", default: 0, null: false, comment: "解答数"
    t.integer "bookships_count", default: 0, null: false, comment: "記事数"
    t.datetime "created_at", null: false
    t.text "description", null: false, comment: "説明"
    t.bigint "folder_id", null: false, comment: "フォルダ"
    t.string "key", null: false
    t.bigint "sequence_id", null: false, comment: "順序"
    t.string "title", limit: 100, null: false, comment: "タイトル"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.index ["access_logs_count"], name: "index_wkbk_books_on_access_logs_count"
    t.index ["folder_id"], name: "index_wkbk_books_on_folder_id"
    t.index ["key"], name: "index_wkbk_books_on_key", unique: true
    t.index ["sequence_id"], name: "index_wkbk_books_on_sequence_id"
    t.index ["user_id"], name: "index_wkbk_books_on_user_id"
  end

  create_table "wkbk_bookships", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "article_id", null: false, comment: "問題"
    t.bigint "book_id", null: false, comment: "問題集"
    t.datetime "created_at", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false, comment: "作成者"
    t.index ["article_id"], name: "index_wkbk_bookships_on_article_id"
    t.index ["book_id", "article_id"], name: "index_wkbk_bookships_on_book_id_and_article_id", unique: true
    t.index ["book_id"], name: "index_wkbk_bookships_on_book_id"
    t.index ["position"], name: "index_wkbk_bookships_on_position"
    t.index ["user_id"], name: "index_wkbk_bookships_on_user_id"
  end

  create_table "wkbk_folders", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "articles_count", default: 0, null: false, comment: "問題数"
    t.integer "books_count", default: 0, null: false, comment: "問題集数"
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_wkbk_folders_on_key", unique: true
    t.index ["position"], name: "index_wkbk_folders_on_position"
  end

  create_table "wkbk_lineages", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_wkbk_lineages_on_key", unique: true
    t.index ["position"], name: "index_wkbk_lineages_on_position"
  end

  create_table "wkbk_moves_answers", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "article_id", null: false, comment: "問題"
    t.datetime "created_at", null: false
    t.integer "moves_count", null: false, comment: "N手"
    t.text "moves_human_str", comment: "人間向け指し手"
    t.text "moves_str", comment: "連続した指し手"
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_wkbk_moves_answers_on_article_id"
    t.index ["moves_count"], name: "index_wkbk_moves_answers_on_moves_count"
    t.index ["position"], name: "index_wkbk_moves_answers_on_position"
  end

  create_table "wkbk_sequences", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_wkbk_sequences_on_key", unique: true
    t.index ["position"], name: "index_wkbk_sequences_on_position"
  end

  create_table "xsettings", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "var_key", null: false
    t.text "var_value"
    t.index ["var_key"], name: "index_xsettings_on_var_key", unique: true
  end

  create_table "xy_master_rules", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "key", null: false
    t.integer "position", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["position"], name: "index_xy_master_rules_on_position"
  end

  create_table "xy_master_time_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "entry_name", null: false
    t.bigint "rule_id", null: false, comment: "ルール"
    t.float "spent_sec", null: false
    t.string "summary"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.integer "x_count", null: false
    t.index ["entry_name"], name: "index_xy_master_time_records_on_entry_name"
    t.index ["rule_id"], name: "index_xy_master_time_records_on_rule_id"
    t.index ["user_id"], name: "index_xy_master_time_records_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "auth_infos", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "swars_crawl_reservations", "users"
  add_foreign_key "swars_memberships", "swars_battles", column: "battle_id"
  add_foreign_key "swars_zip_dl_logs", "users"
  add_foreign_key "wkbk_answer_logs", "users"
  add_foreign_key "wkbk_answer_logs", "wkbk_answer_kinds", column: "answer_kind_id"
  add_foreign_key "wkbk_answer_logs", "wkbk_articles", column: "article_id"
  add_foreign_key "wkbk_answer_logs", "wkbk_books", column: "book_id"
  add_foreign_key "wkbk_articles", "users"
  add_foreign_key "wkbk_articles", "wkbk_folders", column: "folder_id"
  add_foreign_key "wkbk_articles", "wkbk_lineages", column: "lineage_id"
  add_foreign_key "wkbk_books", "users"
  add_foreign_key "wkbk_books", "wkbk_folders", column: "folder_id"
  add_foreign_key "wkbk_books", "wkbk_sequences", column: "sequence_id"
  add_foreign_key "wkbk_bookships", "users"
  add_foreign_key "wkbk_bookships", "wkbk_articles", column: "article_id"
  add_foreign_key "wkbk_bookships", "wkbk_books", column: "book_id"
  add_foreign_key "wkbk_moves_answers", "wkbk_articles", column: "article_id"
end
