class CreatePpl < ActiveRecord::Migration[6.0]
  def up
    drop_table :tsl_users, if_exists: true
    drop_table :tsl_leagues, if_exists: true
    drop_table :tsl_memberships, if_exists: true

    create_table :ppl_users, force: true do |t|
      t.string :name,             null: false, index: { unique: true }, comment: "棋士名"
      t.integer :min_age,         null: true, index: true,              comment: "リーグ入り年齢"
      t.integer :max_age,         null: true, index: true,              comment: "リーグ最後の年齢"
      t.integer :runner_up_count, null: false,                          comment: "次点個数"
      t.integer :max_win,         null: false, index: true,             comment: "最大勝ち数"

      t.belongs_to :promotion_membership, null: true, index: true,      comment: "プロになったときの成績"
      t.integer :promotion_generation,    null: true, index: true,      comment: "プロになった期"
      t.integer :promotion_win,           null: true, index: true,      comment: "プロになったときの勝ち数"

      t.belongs_to :min_membership,       null: true, index: true,      comment: "最初に参加したときの成績"
      t.integer :min_generation,          null: true, index: true,      comment: "最初に参加したときの期"

      t.belongs_to :max_membership,       null: true, index: true,      comment: "最後に参加したときの成績"
      t.integer :max_generation,          null: true, index: true,      comment: "最後に参加したときの期"

      t.integer :memberships_count, :default => 0,                      comment: "参加期間相当"
      t.timestamps
    end

    create_table :ppl_leagues, force: true do |t|
      t.integer :generation, null: false, index: true, comment: "期"
      t.timestamps
    end

    create_table :ppl_memberships, force: true do |t|
      t.belongs_to :league, null: false, index: true,  comment: "リーグ"
      t.belongs_to :user,   null: false, index: true,  comment: "棋士"
      t.belongs_to :result, null: false, index: true,  comment: "結果"
      t.integer :start_pos, null: false, index: true,  comment: "初期順位"
      t.integer :age,       null: true,  index: false, comment: "年齢"
      t.integer :win,       null: false, index: true,  comment: "勝ち数"
      t.integer :lose,      null: false, index: false, comment: "負け数"
      t.string :ox,         null: false, index: false, comment: "勝敗"
      t.index [:league_id, :user_id], unique: true
      t.timestamps
    end

    create_table :ppl_results, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Ppl::Result.reset_column_information
    Ppl::Result.setup
    tp Ppl::Result
  end
end
