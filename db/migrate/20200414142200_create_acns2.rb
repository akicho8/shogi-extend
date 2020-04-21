class CreateAcns2 < ActiveRecord::Migration[6.0]
  def change
    create_table :acns2_rooms do |t|
      t.datetime :begin_at, null: false, index: true, comment: "対戦開始日時"
      t.datetime :end_at,   null: true,  index: true, comment: "対戦終了日時"
      t.string :final_key,  null: true,  index: true, comment: "結果"
      t.timestamps
    end

    create_table :acns2_memberships do |t|
      t.belongs_to :room,                                comment: "対戦部屋"
      t.belongs_to :user,                                comment: "対戦者"
      t.string :judge_key,     null: true,  index: true, comment: "勝敗"
      t.integer :rensho_count, null: false, index: true, comment: "連勝数"
      t.integer :renpai_count, null: false, index: true, comment: "連敗数"
      t.integer :quest_index,                            comment: "解答中の問題"
      t.integer :position,                  index: true, comment: "順序"
      t.timestamps

      t.index [:room_id, :user_id], unique: true
    end

    create_table :acns2_profiles do |t|
      t.belongs_to :user,                                    comment: "対戦者"
      t.integer :rating,           null: false, index: true, comment: "レーティング"
      t.integer :rating_last_diff, null: false, index: true, comment: "直近レーティング変化"
      t.integer :rating_max,       null: false, index: true, comment: "レーティング(最大)"
      t.integer :rensho_count,     null: false, index: true, comment: "連勝数"
      t.integer :renpai_count,     null: false, index: true, comment: "連敗数"
      t.integer :rensho_max,       null: false, index: true, comment: "連勝数(最大)"
      t.integer :renpai_max,       null: false, index: true, comment: "連敗数(最大)"
      t.timestamps
    end

    create_table :acns2_messages do |t|
      t.belongs_to :user,         comment: "対戦者"
      t.belongs_to :room,         comment: "対戦部屋"
      t.string :body, limit: 512, comment: "発言"
      t.timestamps
    end

    create_table :acns2_questions do |t|
      t.belongs_to :user,                                                           comment: "作成者"
      t.string :init_sfen,                    null: false, index: { unique: true }, comment: "問題"
      t.integer :time_limit_sec,              null: true,  index: true,             comment: "制限時間(秒)"
      t.integer :difficulty_level,            null: true,  index: true,             comment: "難易度"
      t.string :title,                        null: true,  index: false,            comment: "タイトル"
      t.string :description,      limit: 512, null: true,  index: false,            comment: "説明"
      t.string :hint_description,             null: true,  index: false,            comment: "ヒント"
      t.string :source_desc,                  null: true,  index: false,            comment: "出典"
      t.string :other_twitter_account,        null: true,  index: false,            comment: "自分以外が作者の場合"
      t.timestamps

      # 別テーブルにするか？
      t.integer :o_count,        null: false, index: true,  comment: "正解数"
      t.integer :x_count,        null: false, index: true,  comment: "不正解数"
    end

    create_table :acns2_moves_answers do |t|
      t.belongs_to :question,                                 comment: "問題"
      t.integer :limit_turn,       null: false, index: true,  comment: "N手"
      t.string :moves_str,   null: false, index: false, comment: "連続した指し手"
      t.timestamps
    end

    create_table :acns2_endpos_answers do |t|
      t.belongs_to :question,                             comment: "問題"
      t.integer :limit_turn,  null: false, index: true,   comment: "N手"
      t.string :sfen_endpos, null: false, index: false,  comment: "最後の局面"
      t.timestamps
    end
  end
end
