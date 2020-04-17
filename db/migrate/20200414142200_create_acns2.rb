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
  end
end
