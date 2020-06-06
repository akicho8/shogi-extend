class CreateActb < ActiveRecord::Migration[6.0]
  def change
    ################################################################################ 静的

    # 問題の種類
    create_table :actb_lineages do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end

    # static
    create_table :actb_ox_marks do |t|
      t.string :key, null: false, index: true, comment: "正解・不正解"
      t.integer :position, null: false, index: true
      t.timestamps
    end

    # 勝ち負け
    create_table :actb_judges do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end

    # ルール
    create_table :actb_rules do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end

    # 結果
    create_table :actb_finals do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end

    ################################################################################

    create_table :actb_rooms do |t|
      t.datetime :begin_at,     null: false, index: true, comment: "対戦開始日時"
      t.datetime :end_at,       null: true,  index: true, comment: "対戦終了日時"
      t.belongs_to :rule,       null: false,              comment: "ルール"
      t.timestamps
      t.integer :battles_count, null: false, index: true, default: 0, comment: "連戦数"
    end

    create_table :actb_room_memberships do |t|
      t.belongs_to :room,  null: false,              comment: "対戦部屋"
      t.belongs_to :user,  null: false,              comment: "対戦者"
      t.integer :position, null: false, index: true, comment: "順序"
      t.timestamps
      t.index [:room_id, :user_id], unique: true
    end

    create_table :actb_battles do |t|
      t.belongs_to :room,      null: false,               comment: "部屋"
      t.belongs_to :parent,    null: true,                comment: "親"
      t.belongs_to :rule,      null: false,               comment: "ルール"
      t.belongs_to :final,     null: false,               comment: "結果"
      t.datetime :begin_at,    null: false,  index: true, comment: "対戦開始日時"
      t.datetime :end_at,      null: true,   index: true, comment: "対戦終了日時"
      t.integer :rensen_index, null: false,  index: true, comment: "連戦数"
      t.timestamps
    end

    # Actb::BattleMembership
    create_table :actb_battle_memberships do |t|
      t.belongs_to :battle,    null: false,              comment: "対戦"
      t.belongs_to :user,      null: false,              comment: "対戦者"
      t.belongs_to :judge,     null: false,              comment: "勝敗"
      t.integer :position,     null: false, index: true, comment: "順序"
      t.timestamps

      t.index [:battle_id, :user_id], unique: true
    end

    create_table :actb_settings do |t|
      t.belongs_to :user, null: false, comment: "自分"
      t.belongs_to :rule, null: false, comment: "選択ルール"
      t.timestamps
    end

    # Actb::MasterXrecord
    create_table :actb_master_xrecords do |t|
      t.belongs_to :user,          null: false, index: { unique: true }, comment: "対戦者"
      t.belongs_to :judge,         null: false,                          comment: "直前の勝敗"
      t.belongs_to :final,         null: false,                          comment: "直前の結果"
      t.integer :battle_count,     null: false, index: true,             comment: "対戦数"
      t.integer :win_count,        null: false, index: true,             comment: "勝ち数"
      t.integer :lose_count,       null: false, index: true,             comment: "負け数"
      t.float   :win_rate,         null: false, index: true,             comment: "勝率"
      t.integer :rating,           null: false, index: true,             comment: "レーティング"
      t.integer :rating_last_diff, null: false, index: true,             comment: "直近レーティング変化"
      t.integer :rating_max,       null: false, index: true,             comment: "レーティング(最大)"
      t.integer :rensho_count,     null: false, index: true,             comment: "連勝数"
      t.integer :renpai_count,     null: false, index: true,             comment: "連敗数"
      t.integer :rensho_max,       null: false, index: true,             comment: "連勝数(最大)"
      t.integer :renpai_max,       null: false, index: true,             comment: "連敗数(最大)"
      t.timestamps

      t.integer  :disconnect_count, null: false, index: true, comment: "切断数"
      t.datetime :disconnected_at,  null: true,               comment: "最終切断日時"

      # t.index [:user_id, :season_id], unique: true
    end

    # Actb::SeasonXrecord
    create_table :actb_season_xrecords do |t|
      t.belongs_to :user,          null: false,              comment: "対戦者"
      t.belongs_to :season,        null: false,              comment: "期"
      t.belongs_to :judge,         null: false,              comment: "直前の勝敗"
      t.belongs_to :final,         null: false,              comment: "直前の結果"
      t.integer :battle_count,     null: false, index: true, comment: "対戦数"
      t.integer :win_count,        null: false, index: true, comment: "勝ち数"
      t.integer :lose_count,       null: false, index: true, comment: "負け数"
      t.float   :win_rate,         null: false, index: true, comment: "勝率"
      t.integer :rating,           null: false, index: true, comment: "レーティング"
      t.integer :rating_last_diff, null: false, index: true, comment: "直近レーティング変化"
      t.integer :rating_max,       null: false, index: true, comment: "レーティング(最大)"
      t.integer :rensho_count,     null: false, index: true, comment: "連勝数"
      t.integer :renpai_count,     null: false, index: true, comment: "連敗数"
      t.integer :rensho_max,       null: false, index: true, comment: "連勝数(最大)"
      t.integer :renpai_max,       null: false, index: true, comment: "連敗数(最大)"
      t.integer :create_count,     null: false, index: true, comment: "users.actb_season_xrecord.create_count は users.actb_season_xrecords.count と一致"
      t.integer :generation,       null: false, index: true, comment: "世代(seasons.generationと一致)"
      t.timestamps

      t.integer  :disconnect_count, null: false, index: true, comment: "切断数"
      t.datetime :disconnected_at,  null: true,               comment: "最終切断日時"

      t.index [:user_id, :season_id], unique: true
    end

    create_table :actb_seasons do |t|
      t.string :name,        null: false, index: false, comment: "レーティング"
      t.integer :generation, null: false, index: true,  comment: "世代"
      t.datetime :begin_at,  null: false, index: true,  comment: "期間開始日時"
      t.datetime :end_at,    null: false, index: true,  comment: "期間終了日時"
      t.timestamps
    end

    create_table :actb_histories do |t|
      t.belongs_to :user,     null: false, comment: "自分"
      t.belongs_to :question, null: false, comment: "出題"
      t.timestamps

      #  おまけ
      t.belongs_to :room,        null: false,               comment: "部屋"
      t.belongs_to :battle,      null: false,               comment: "対戦"
      t.belongs_to :membership,  null: false,               comment: "自分と相手"
      t.belongs_to :ox_mark,     null: false,               comment: "解答"
      t.integer :rating,         null: false, index: false, comment: "レーティング"
    end

    ################################################################################

    # 未使用
    create_table :actb_favorites do |t|
      t.belongs_to :user,      null: false, comment: "自分"
      t.belongs_to :question,  null: false, comment: "出題"
      t.integer :score,        null: false, comment: "スコア"
      t.timestamps
    end

    create_table :actb_good_marks do |t|
      t.belongs_to :user,      null: false,comment: "自分"
      t.belongs_to :question,  null: false,comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    create_table :actb_bad_marks do |t|
      t.belongs_to :user,      null: false, comment: "自分"
      t.belongs_to :question,  null: false, comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    create_table :actb_clip_marks do |t|
      t.belongs_to :user,      null: false,comment: "自分"
      t.belongs_to :question,  null: false,comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    ################################################################################

    create_table :actb_room_messages do |t|
      t.belongs_to :user,         null: false, comment: "対戦者"
      t.belongs_to :room,         null: false, comment: "対戦部屋"
      t.string :body, limit: 140, null: false, comment: "発言"
      t.timestamps
    end

    create_table :actb_lobby_messages do |t|
      t.belongs_to :user,         null: false, comment: "対戦者"
      t.string :body, limit: 140, null: false, comment: "発言"
      t.timestamps
    end

    create_table :actb_question_messages do |t|
      t.belongs_to :user,          null: false, comment: "発言者"
      t.belongs_to :question,      null: false, comment: "問題"
      t.string :body, limit: 140,  null: false, comment: "発言"
      t.timestamps
    end

    create_table :actb_questions do |t|
      t.belongs_to :user,    null: false, comment: "作成者"
      t.belongs_to :folder,  null: false, comment: "フォルダ"
      t.belongs_to :lineage, null: false, comment: "種類"

      t.string :init_sfen,               null: false, index: true,  comment: "問題"
      t.integer :time_limit_sec,         null: true,  index: true,  comment: "制限時間(秒)"
      t.integer :difficulty_level,       null: true,  index: true,  comment: "難易度"
      t.string :title,                   null: true,  index: false, comment: "タイトル"
      t.string :description, limit: 512, null: true,  index: false, comment: "説明"
      t.string :hint_desc,        null: true,  index: false, comment: "ヒント"
      t.string :other_author,             null: true,  index: false, comment: "作者"
      t.string :other_author_link,   null: true,  index: false, comment:  "作者へのリンク"
      t.timestamps

      t.integer :moves_answers_count,  null: false, index: true, default: 0, comment: "A解答数"
      t.integer :endpos_answers_count, null: false, index: true, default: 0, comment: "B解答数"

      # 別テーブルにするか？
      t.integer :o_count, null: false, index: true,  comment: "正解数"
      t.integer :x_count, null: false, index: true,  comment: "不正解数"

      t.integer :bad_count,  null: false, comment: "高評価数"
      t.integer :good_count, null: false, comment: "低評価数"

      # counter_cache
      t.integer :histories_count,  default: 0, null: false, comment: "履歴数(出題数とは異なる)"
      t.integer :favorites_count,  default: 0, null: false, comment: "高評価数+低評価数になっていないと不整合"
      t.integer :good_marks_count, default: 0, null: false, comment: "高評価数"
      t.integer :bad_marks_count,  default: 0, null: false, comment: "低評価数"
      t.integer :clip_marks_count, default: 0, null: false, comment: "保存された数"
      t.integer :messages_count,   default: 0, null: false, comment: "コメント数"
    end

    # MovesAnswer
    create_table :actb_moves_answers do |t|
      t.belongs_to :question, null: false,               comment: "問題"
      t.integer :moves_count, null: false, index: true,  comment: "N手"
      t.string :moves_str,    null: false, index: false, comment: "連続した指し手"
      t.string :end_sfen,     null: true,  index: false, comment: "最後の局面"
      t.timestamps
    end

    # 未使用
    create_table :actb_endpos_answers do |t|
      t.belongs_to :question, null: false,               comment: "問題"
      t.integer :moves_count, null: false, index: true,  comment: "N手"
      t.string :end_sfen,     null: false, index: false, comment: "最後の局面"
      t.timestamps
    end

    # フォルダ
    create_table :actb_folders do |t|
      t.belongs_to :user,  null: false
      t.string :type, null: false, comment: "for STI"
      t.timestamps
      t.index [:type, :user_id], unique: true
    end
  end
end
