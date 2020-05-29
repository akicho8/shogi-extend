class CreateActb < ActiveRecord::Migration[6.0]
  def change
    create_table :actb_rooms do |t|
      t.datetime :begin_at,     null: false, index: true, comment: "対戦開始日時"
      t.datetime :end_at,       null: true,  index: true, comment: "対戦終了日時"
      t.string :rule_key,       null: false, index: true, comment: "ルール"
      t.timestamps
      t.integer :battles_count, null: false, index: true, default: 0, comment: "連戦数"
    end

    create_table :actb_room_memberships do |t|
      t.belongs_to :room,                                comment: "対戦部屋"
      t.belongs_to :user,                                comment: "対戦者"
      # t.string :judge_key,     null: true,  index: true, comment: "勝敗"
      # t.integer :rensho_count, null: false, index: true, comment: "連勝数"
      # t.integer :renpai_count, null: false, index: true, comment: "連敗数"
      # t.integer :question_index,                            comment: "解答中の問題"
      t.integer :position,                  index: true, comment: "順序"
      t.timestamps
      t.index [:room_id, :user_id], unique: true
    end

    create_table :actb_battles do |t|
      t.belongs_to :room,                                 comment: "部屋"
      t.belongs_to :parent,    null: true,                comment: "親"
      t.datetime :begin_at,    null: false,  index: true, comment: "対戦開始日時"
      t.datetime :end_at,      null: true,   index: true, comment: "対戦終了日時"
      t.string :final_key,     null: true,   index: true, comment: "結果"
      t.string :rule_key,      null: false,  index: true, comment: "ルール"
      t.integer :rensen_index, null: false,  index: true, comment: "連戦数"
      t.timestamps
    end

    create_table :actb_battle_memberships do |t|
      t.belongs_to :battle,                              comment: "対戦"
      t.belongs_to :user,                                comment: "対戦者"
      t.string :judge_key,     null: true,  index: true, comment: "勝敗"
      t.integer :rensho_count, null: false, index: true, comment: "連勝数"
      t.integer :renpai_count, null: false, index: true, comment: "連敗数"
      t.integer :question_index,                         comment: "解答中の問題"
      t.integer :position,                  index: true, comment: "順序"
      t.timestamps

      t.index [:battle_id, :user_id], unique: true
    end

    create_table :actb_settings do |t|
      t.belongs_to :user,                                     comment: "自分"
      t.string :rule_key,           null: false, index: true, comment: "最後に選択したルール"
      t.timestamps
    end

    create_table :actb_profiles do |t|
      t.belongs_to :user,                                    comment: "対戦者"
      t.belongs_to :season,                                  comment: "期"
      t.integer :rating,           null: false, index: true, comment: "レーティング"
      t.integer :rating_last_diff, null: false, index: true, comment: "直近レーティング変化"
      t.integer :rating_max,       null: false, index: true, comment: "レーティング(最大)"
      t.integer :rensho_count,     null: false, index: true, comment: "連勝数"
      t.integer :renpai_count,     null: false, index: true, comment: "連敗数"
      t.integer :rensho_max,       null: false, index: true, comment: "連勝数(最大)"
      t.integer :renpai_max,       null: false, index: true, comment: "連敗数(最大)"
      t.integer :create_count,     null: false, index: true, comment: "users.actb_profile.create_count は users.actb_profiles.count と一致"
      t.integer :generation,       null: false, index: true, comment: "世代(seasons.generationと一致)"
      t.timestamps

      t.index [:user_id, :season_id], unique: true
    end

    create_table :actb_seasons do |t|
      t.string :name,        null: false, index: false, comment: "レーティング"
      t.integer :generation, null: false, index: true,  comment: "世代"
      t.datetime :begin_at,  null: false, index: true, comment: "期間開始日時"
      t.datetime :end_at,    null: false, index: true, comment: "期間終了日時"
      t.timestamps
    end

    create_table :actb_histories do |t|
      t.belongs_to :user,       comment: "自分"
      t.belongs_to :question,   comment: "出題"
      t.timestamps
      #  おまけ
      t.belongs_to :room,       comment: "部屋"
      t.belongs_to :battle,     comment: "対戦"
      t.belongs_to :membership, comment: "自分と相手"
      t.belongs_to :ox_mark,    comment: "解答"
    end

    # 未使用
    create_table :actb_favorites do |t|
      t.belongs_to :user,     comment: "自分"
      t.belongs_to :question, comment: "出題"
      t.integer :score,       comment: "スコア"
      t.timestamps
    end

    create_table :actb_good_marks do |t|
      t.belongs_to :user,     comment: "自分"
      t.belongs_to :question, comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    create_table :actb_bad_marks do |t|
      t.belongs_to :user,     comment: "自分"
      t.belongs_to :question, comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    create_table :actb_clip_marks do |t|
      t.belongs_to :user,     comment: "自分"
      t.belongs_to :question, comment: "出題"
      t.timestamps
      t.index [:user_id, :question_id], unique: true
    end

    # static
    create_table :actb_ox_marks do |t|
      t.string :key, null: false, index: true, comment: "正解・不正解"
      t.timestamps
    end

    create_table :actb_room_messages do |t|
      t.belongs_to :user,         comment: "対戦者"
      t.belongs_to :room,         comment: "対戦部屋"
      t.string :body, limit: 140, comment: "発言"
      t.timestamps
    end

    create_table :actb_lobby_messages do |t|
      t.belongs_to :user,         comment: "対戦者"
      t.string :body, limit: 140, comment: "発言"
      t.timestamps
    end

    create_table :actb_question_messages do |t|
      t.belongs_to :user,         comment: "発言者"
      t.belongs_to :question,     comment: "問題"
      t.string :body, limit: 140, comment: "発言"
      t.timestamps
    end

    create_table :actb_questions do |t|
      t.belongs_to :user,                                                comment: "作成者"
      t.belongs_to :folder,                                              comment: "フォルダ"
      t.belongs_to :lineage,                                                comment: "種類"

      t.string :init_sfen,                    null: false, index: true,  comment: "問題"
      t.integer :time_limit_sec,              null: true,  index: true,  comment: "制限時間(秒)"
      t.integer :difficulty_level,            null: true,  index: true,  comment: "難易度"
      t.string :title,                        null: true,  index: false, comment: "タイトル"
      t.string :description,      limit: 512, null: true,  index: false, comment: "説明"
      t.string :hint_description,             null: true,  index: false, comment: "ヒント"
      t.string :source_desc,                  null: true,  index: false, comment: "出典"
      t.string :other_twitter_account,        null: true,  index: false, comment: "自分以外が作者の場合"
      t.timestamps

      t.integer :moves_answers_count,         null: false, index: true, default: 0, comment: "A解答数"
      t.integer :endpos_answers_count,        null: false, index: true, default: 0, comment: "B解答数"

      # 別テーブルにするか？
      t.integer :o_count,        null: false, index: true,  comment: "正解数"
      t.integer :x_count,        null: false, index: true,  comment: "不正解数"

      t.integer :bad_count,  null: false, comment: "高評価数"
      t.integer :good_count, null: false, comment: "低評価数"

      # counter_cache
      t.integer :histories_count,  default: 0, null: false, comment: "履歴数"
      t.integer :favorites_count,  default: 0, null: false, comment: "高評価数+低評価数になっていないと不整合"
      t.integer :bad_marks_count,  default: 0, null: false, comment: "高評価数"
      t.integer :good_marks_count, default: 0, null: false, comment: "低評価数"
      t.integer :clip_marks_count, default: 0, null: false, comment: "保存された数"
      t.integer :messages_count,   default: 0, null: false, comment: "コメント数"
    end

    # MovesAnswer
    create_table :actb_moves_answers do |t|
      t.belongs_to :question,                           comment: "問題"
      t.integer :moves_count, null: false, index: true,  comment: "N手"
      t.string :moves_str,   null: false, index: false, comment: "連続した指し手"
      t.string :end_sfen,    null: true,  index: false, comment: "最後の局面"
      t.timestamps
    end

    # 未使用
    create_table :actb_endpos_answers do |t|
      t.belongs_to :question,                            comment: "問題"
      t.integer :moves_count,  null: false, index: true,  comment: "N手"
      t.string :end_sfen,  null: false, index: false, comment: "最後の局面"
      t.timestamps
    end

    # フォルダ
    create_table :actb_folders do |t|
      t.belongs_to :user
      t.string :type, null: false
      t.timestamps

      t.index [:type, :user_id], unique: true
    end

    # 種類
    create_table :actb_lineages do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end
  end
end
