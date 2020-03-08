class CreateSwars < ActiveRecord::Migration[5.1]
  def change
    create_table :swars_users, force: true do |t|
      t.string :user_key, null: false, index: {unique: true}, comment: "対局者名"
      t.belongs_to :grade, null: false, comment: "最高段級"
      t.datetime :last_reception_at, null: true, comment: "受容日時"
      t.integer :search_logs_count, default: 0
      t.timestamps null: false
    end

    create_table :swars_battles, force: true do |t|
      t.string :key, null: false, index: {unique: true}, comment: "対局識別子"
      t.datetime :battled_at, null: false, comment: "対局開始日時"
      t.string :rule_key, null: false, index: true, comment: "ルール"
      t.text :csa_seq, null: false, comment: "棋譜の断片"
      t.string :final_key, null: false, index: true, comment: "結果詳細"
      t.belongs_to :win_user, comment: "勝者(ショートカット用)"

      t.integer :turn_max, null: false, comment: "手数"
      t.text :meta_info, null: false, comment: "棋譜メタ情報"

      t.datetime :accessed_at, null: false, comment: "最終参照日時"
      t.integer :outbreak_turn, index: true, null: true, comment: "仕掛手数"

      t.timestamps null: false
    end

    create_table :swars_memberships, force: true do |t|
      t.belongs_to :battle, null: false, comment: "対局"
      t.belongs_to :user, null: false, comment: "対局者"
      t.belongs_to :grade, null: false, comment: "対局時の段級"
      t.string :judge_key, null: false, index: true, comment: "勝・敗・引き分け"
      t.string :location_key, null: false, index: true, comment: "▲△"
      t.integer :position, index: true, comment: "手番の順序"
      t.timestamps null: false

      t.index [:battle_id, :location_key], unique: true, name: :memberships_sbri_lk
      t.index [:battle_id, :user_id], unique: true, name: :memberships_sbri_sbui
    end

    create_table :swars_grades, force: true do |t|
      t.string :key, null: false, index: {unique: true}
      t.integer :priority, null: false, index: true, comment: "優劣"
      t.timestamps null: false
    end

    create_table :swars_search_logs, force: true do |t|
      t.belongs_to :user, null: false, comment: "プレイヤー"
      t.timestamps null: false
    end
  end
end
