class CreateSwars < ActiveRecord::Migration[5.1]
  def change
    create_table :swars_users, force: true do |t|
      t.string :user_key,            null: false, index: {unique: true}, comment: "対局者名"
      t.belongs_to :grade,           null: false, comment: "最高段級"
      t.datetime :last_reception_at, null: true, index: true, comment: "受容日時"
      t.integer :search_logs_count,  null: true, default: 0
      t.timestamps                   null: false

      t.index :updated_at
    end

    create_table :swars_battles, force: true do |t|
      t.string :key,            null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at,   null: false, index: true, comment: "対局開始日時"
      t.string :rule_key,       null: false, index: true, comment: "ルール"
      t.text :csa_seq,          null: false, comment: "棋譜の断片"
      t.string :final_key,      null: false, index: true, comment: "結果詳細"
      t.belongs_to :win_user,   null: true, comment: "勝者(ショートカット用)"

      t.integer :turn_max,      null: false, index: true, comment: "手数"
      t.text :meta_info,        null: false, comment: "棋譜メタ情報"

      t.datetime :accessed_at,  null: false, comment: "最終参照日時"

      t.string :preset_key,     null: false, index: true

      t.string :sfen_body,      null: false, limit: 8192
      t.string :sfen_hash,      null: false

      t.integer :start_turn,    null: true, index: true, comment: "???"
      t.integer :critical_turn, null: true, index: true, comment: "開戦"
      t.integer :outbreak_turn, null: true, index: true, comment: "中盤"
      t.integer :image_turn,    null: true,              comment: "???"

      t.timestamps              null: false
    end

    create_table :swars_memberships, force: true do |t|
      t.belongs_to :battle,   null: false,              comment: "対局"
      t.belongs_to :user,     null: false,              comment: "対局者"
      t.belongs_to :op_user,  null: true,               comment: "相手"
      t.belongs_to :grade,    null: false,              comment: "対局時の段級"
      t.string :judge_key,    null: false, index: true, comment: "勝・敗・引き分け"
      t.string :location_key, null: false, index: true, comment: "▲△"
      t.integer :position,    null: true,  index: true, comment: "手番の順序"
      t.integer :grade_diff,  null: false
      t.timestamps null: false

      # optional
      t.integer :think_all_avg,  null: true, comment: "指し手の平均秒数(全体)"
      t.integer :think_end_avg,  null: true, comment: "指し手の平均秒数(最後5手)"
      t.integer :two_serial_max, null: true, comment: "2秒の指し手が連続した回数"
      t.integer :think_last,     null: true, comment: "最後の指し手の秒数"
      t.integer :think_max,      null: true, comment: "最大考慮秒数"

      t.index [:battle_id, :location_key], unique: true, name: :memberships_sbri_lk
      t.index [:battle_id, :user_id],      unique: true, name: :memberships_sbri_sbui
      t.index [:battle_id, :op_user_id],   unique: true, name: :memberships_bid_ouid
    end

    create_table :swars_grades, force: true do |t|
      t.string :key,       null: false, index: {unique: true}
      t.integer :priority, null: false, index: true, comment: "優劣"
      t.timestamps         null: false
    end

    create_table :swars_search_logs, force: true do |t|
      t.belongs_to :user, null: false, comment: "プレイヤー"
      t.timestamps        null: false
    end

    create_table :swars_crawl_reservations, force: true do |t|
      t.belongs_to :user,        null: false, foreign_key: true, comment: "登録者"
      t.string :target_user_key, null: false,                    comment: "対象者"
      t.string :to_email,        null: false,                    comment: "完了通知先メールアドレス"
      t.string :attachment_mode, null: false, index: true,       comment: "ZIPファイル添付の有無"
      t.datetime :processed_at,                                  comment: "処理完了日時"
      t.timestamps               null: false
    end
  end
end
