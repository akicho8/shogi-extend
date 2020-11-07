class CreateEmox < ActiveRecord::Migration[6.0]
  def change
    DbCop.foreign_key_checks_disable do
      ################################################################################ 静的

      # フォルダ
      create_table :emox_folders, force: true do |t|
        t.belongs_to :user, foreign_key: true,  null: false
        t.string :type, null: false, comment: "for STI"
        t.timestamps
        t.index [:type, :user_id], unique: true
      end

      # 問題の種類
      create_table :emox_lineages, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # static
      create_table :emox_ox_marks, force: true do |t|
        t.string :key, null: false, index: true, comment: "正解・不正解"
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # 勝ち負け
      create_table :emox_judges, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # ルール
      create_table :emox_rules, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # 結果
      create_table :emox_finals, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # ウデマエ
      create_table :emox_skills, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      ################################################################################

      create_table :emox_rooms, force: true do |t|
        t.datetime :begin_at,     null: false, index: true, comment: "対戦開始日時"
        t.datetime :end_at,       null: true,  index: true, comment: "対戦終了日時"
        t.belongs_to :rule, foreign_key: {to_table: :emox_rules}, null: false,              comment: "ルール"
        t.timestamps
        t.integer :battles_count, null: false, index: true, default: 0, comment: "連戦数"
        t.boolean :practice, null: true, comment: "練習バトル？"
        t.belongs_to :bot_user, foreign_key: {to_table: :users}, null: true, comment: "練習相手"
      end

      create_table :emox_room_memberships, force: true do |t|
        t.belongs_to :room, foreign_key: {to_table: :emox_rooms},  null: false,              comment: "対戦部屋"
        t.belongs_to :user, foreign_key: true,  null: false,              comment: "対戦者"
        t.integer :position, null: false, index: true, comment: "順序"
        t.timestamps
        t.index [:room_id, :user_id], unique: true
      end

      create_table :emox_battles, force: true do |t|
        t.belongs_to :room,   foreign_key: {to_table: :emox_rooms},      null: false,               comment: "部屋"
        t.belongs_to :parent, foreign_key: {to_table: :emox_battles},    null: true,                comment: "親"
        t.belongs_to :rule,   foreign_key: {to_table: :emox_rules},      null: false,               comment: "ルール"
        t.belongs_to :final,  foreign_key: {to_table: :emox_finals},     null: false,               comment: "結果"
        t.datetime :begin_at,    null: false,  index: true, comment: "対戦開始日時"
        t.datetime :end_at,      null: true,   index: true, comment: "対戦終了日時"
        t.integer :battle_pos, null: false,  index: true, comment: "連戦インデックス"
        t.boolean :practice, null: true, comment: "練習バトル？"
        t.timestamps
      end

      # Emox::BattleMembership
      create_table :emox_battle_memberships, force: true do |t|
        t.belongs_to :battle, foreign_key: {to_table: :emox_battles},    null: false,              comment: "対戦"
        t.belongs_to :user, foreign_key: true,      null: false,              comment: "対戦者"
        t.belongs_to :judge, foreign_key: {to_table: :emox_judges},     null: false,              comment: "勝敗"
        t.integer :position,     null: false, index: true, comment: "順序"
        t.timestamps

        t.index [:battle_id, :user_id], unique: true
      end

      create_table :emox_settings, force: true do |t|
        t.belongs_to :user, foreign_key: true, null: false, comment: "自分"
        t.belongs_to :rule, foreign_key: {to_table: :emox_rules}, null: false, comment: "選択ルール"
        t.string :session_lock_token, null: true, comment: "複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン"
        t.timestamps
      end

      # Emox::MainXrecord
      common_columns_define = -> t {
        t.belongs_to :judge, foreign_key: {to_table: :emox_judges},                                 null: false,               comment: "直前の勝敗"
        t.belongs_to :final, foreign_key: {to_table: :emox_finals},                                 null: false,               comment: "直前の結果"
        t.integer :battle_count,                             null: false, index: true,  comment: "対戦数"
        t.integer :win_count,                                null: false, index: true,  comment: "勝ち数"
        t.integer :lose_count,                               null: false, index: true,  comment: "負け数"
        t.float   :win_rate,                                 null: false, index: true,  comment: "勝率"

        t.float :rating, null: false, index: true,  comment: "レーティング"
        t.float :rating_diff,  null: false, index: true,  comment: "直近レーティング変化"
        t.float :rating_max,        null: false, index: true,  comment: "レーティング(最大)"

        t.integer :straight_win_count,                             null: false, index: true,  comment: "連勝数"
        t.integer :straight_lose_count,                             null: false, index: true,  comment: "連敗数"

        t.integer :straight_win_max,                               null: false, index: true,  comment: "連勝数(最大)"
        t.integer :straight_lose_max,                               null: false, index: true,  comment: "連敗数(最大)"

        t.belongs_to :skill, foreign_key: {to_table: :emox_skills},                                null: false, index: true,  comment: "ウデマエ"
        t.float :skill_point,      null: false, index: false, comment: "ウデマエの内部ポイント"
        t.float :skill_last_diff,  null: false, index: false, comment: "直近ウデマエ変化度"

        t.timestamps

        t.integer  :disconnect_count, null: false, index: true, comment: "切断数"
        t.datetime :disconnected_at,  null: true,               comment: "最終切断日時"
      }

      create_table :emox_main_xrecords, force: true do |t|
        t.belongs_to :user, foreign_key: true, null: false, index: { unique: true }, comment: "対戦者"
        common_columns_define.call(t)
      end

      create_table :emox_seasons, force: true do |t|
        t.string :name,        null: false, index: false, comment: "レーティング"
        t.integer :generation, null: false, index: true,  comment: "世代"
        t.datetime :begin_at,  null: false, index: true,  comment: "期間開始日時"
        t.datetime :end_at,    null: false, index: true,  comment: "期間終了日時"
        t.timestamps
      end

      # Emox::SeasonXrecord
      create_table :emox_season_xrecords, force: true do |t|
        common_columns_define.call(t)
        t.belongs_to :user, foreign_key: true,          null: false, index: true, comment: "対戦者"
        t.belongs_to :season, foreign_key: {to_table: :emox_seasons},        null: false,              comment: "期"
        t.integer :create_count,     null: false, index: true, comment: "users.emox_season_xrecord.create_count は users.emox_season_xrecords.count と一致"
        t.integer :generation,       null: false, index: true, comment: "世代(seasons.generationと一致)"
        t.index [:user_id, :season_id], unique: true
      end

      ################################################################################

      create_table :emox_room_messages, force: true do |t|
        t.belongs_to :user, foreign_key: true,         null: false, comment: "対戦者"
        t.belongs_to :room, foreign_key: {to_table: :emox_rooms},         null: false, comment: "対戦部屋"
        t.string :body, limit: 512, null: false, comment: "発言"
        t.timestamps
      end

      create_table :emox_lobby_messages, force: true do |t|
        t.belongs_to :user, foreign_key: true,         null: false, comment: "対戦者"
        t.string :body, limit: 512, null: false, comment: "発言"
        t.timestamps
      end

      create_table :emox_questions, force: true do |t|
        t.string :key, null: false, index: true

        t.belongs_to :user,    null: false, foreign_key: true,                          comment: "作成者"
        t.belongs_to :folder,  null: false, foreign_key: {to_table: :emox_folders},   comment: "フォルダ"
        t.belongs_to :lineage, null: false, foreign_key: {to_table: :emox_lineages}, comment: "種類"

        t.string :init_sfen,               null: false, index: true,                                  comment: "問題"
        t.integer :time_limit_sec,         null: true,  index: true,                                  comment: "制限時間(秒)"
        t.integer :difficulty_level,       null: true,  index: true,                                  comment: "難易度"
        t.string :title,                   null: true,  index: false,                                 comment: "タイトル"
        t.string :description, limit: 512, null: true,  index: false,                                 comment: "説明"
        t.string :hint_desc,               null: true,  index: false,                                 comment: "ヒント"
        t.string :source_author,           null: true,  index: false,                                 comment: "作者"
        t.string :source_media_name,       null: true,  index: false,                                 comment: "出典メディア"
        t.string :source_media_url,        null: true,  index: false,                                 comment: "出典URL"
        t.date :source_published_on,       null: true,  index: false,                                 comment: "出典年月日"
        t.belongs_to :source_about,        null: true,  foreign_key: {to_table: :emox_source_abouts}, comment: "所在"
        t.integer :turn_max,               null: true,  index: true,                                  comment: "最大手数"
        t.boolean :mate_skip,              null: true,                                                comment: "詰みチェックをスキップする"
        t.string :direction_message,       null: true,                                                comment: "メッセージ"

        t.timestamps

        t.float :good_rate, null: true, index: true, comment: "高評価率"

        # counter_cache
        t.integer :moves_answers_count, default: 0, null: false, index: false, comment: "解答数"
        t.integer :histories_count,     default: 0, null: false, index: true,  comment: "履歴数(出題数とは異なる)"
        t.integer :good_marks_count,    default: 0, null: false, index: true,  comment: "高評価数"
        t.integer :bad_marks_count,     default: 0, null: false, index: true,  comment: "低評価数"
        t.integer :clip_marks_count,    default: 0, null: false, index: true,  comment: "保存された数"
        t.integer :messages_count,      default: 0, null: false, index: true,  comment: "コメント数"
      end

      create_table :emox_source_abouts, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      ################################################################################

      create_table :emox_good_marks, force: true do |t|
        t.belongs_to :user, foreign_key: true,      null: false,comment: "自分"
        t.belongs_to :question, foreign_key: {to_table: :emox_questions},  null: false,comment: "出題"
        t.timestamps
        t.index [:user_id, :question_id], unique: true
      end

      create_table :emox_bad_marks, force: true do |t|
        t.belongs_to :user, foreign_key: true,      null: false, comment: "自分"
        t.belongs_to :question, foreign_key: {to_table: :emox_questions},  null: false, comment: "出題"
        t.timestamps
        t.index [:user_id, :question_id], unique: true
      end

      create_table :emox_clip_marks, force: true do |t|
        t.belongs_to :user, foreign_key: true,      null: false,comment: "自分"
        t.belongs_to :question, foreign_key: {to_table: :emox_questions},  null: false,comment: "出題"
        t.timestamps
        t.index [:user_id, :question_id], unique: true
      end

      create_table :emox_question_messages, force: true do |t|
        t.belongs_to :user, foreign_key: true,          null: false, comment: "発言者"
        t.belongs_to :question, foreign_key: {to_table: :emox_questions},      null: false, comment: "問題"
        t.string :body, limit: 512,  null: false, comment: "発言"
        t.timestamps
      end

      create_table :emox_histories, force: true do |t|
        t.belongs_to :user, foreign_key: true,     null: false, comment: "自分"
        t.belongs_to :question, foreign_key: {to_table: :emox_questions}, null: false, comment: "出題"
        t.belongs_to :room, foreign_key: {to_table: :emox_rooms}, null: true, comment: "対戦部屋"
        t.timestamps

        #  おまけ
        t.belongs_to :ox_mark, foreign_key: {to_table: :emox_ox_marks},     null: false,               comment: "解答"
      end

      create_table :emox_ox_records, force: true do |t|
        t.belongs_to :question, foreign_key: {to_table: :emox_questions},                    null: false, index: { unique: true }, comment: "問題"
        t.integer :o_count,                        null: false, index: true,             comment: "正解数"
        t.integer :x_count,                        null: false, index: true,             comment: "不正解数"
        t.integer :ox_total,                       null: false, index: true,             comment: "出題数"
        t.float :o_rate, null: true, index: true,             comment: "高評価率"
        t.timestamps
      end

      # MovesAnswer
      create_table :emox_moves_answers, force: true do |t|
        t.belongs_to :question, foreign_key: {to_table: :emox_questions}, null: false,               comment: "問題"
        t.integer :moves_count, null: false, index: true,  comment: "N手"
        t.string :moves_str,    null: false, index: false, comment: "連続した指し手"
        t.string :end_sfen,     null: true,  index: false, comment: "最後の局面"
        t.string :moves_human_str, null: true, index: false, comment: "人間向け指し手"
        t.timestamps
      end

      create_table :emox_notifications, force: true do |t|
        t.belongs_to :question_message, foreign_key: { to_table: :emox_question_messages }, null: false, comment: "問題コメント"
        t.belongs_to :user,             foreign_key: { to_table: :users                  }, null: false, comment: "通知先"
        t.datetime   :opened_at,                                                            null: true,  comment: "開封日時"
        t.timestamps
      end

      create_table :emox_emotion_folders, force: true do |t|
        t.string :key,       null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end
      create_table :emox_emotions, force: true do |t|
        t.belongs_to :user,     foreign_key: true,                              null: false, comment: "所有者"
        t.belongs_to :folder, foreign_key: { to_table: :emox_emotion_folders }, null: false, comment: "フォルダ"
        t.string :name,                                                         null: false, comment: "トリガー名"
        t.string :message,                                                      null: false, comment: "表示用伝言"
        t.string :voice,                                                        null: false, comment: "発声用文言"
        t.integer :position, null: false, index: true
        t.timestamps
      end

      create_table :emox_vs_records, force: true do |t|
        t.belongs_to :battle, foreign_key: {to_table: :emox_battles},    null: false, comment: "対戦"
        t.string :sfen_body, limit: 1536, null: false, index: false,                  comment: "棋譜"
        t.timestamps
      end
    end
  end
end
