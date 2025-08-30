class CreatePpl < ActiveRecord::Migration[6.0]
  def up
    drop_table :tsl_users,          if_exists: true
    drop_table :tsl_seasons, if_exists: true
    drop_table :tsl_memberships,    if_exists: true

    create_table :ppl_mentors, force: true do |t|
      t.string :name,         null: false, index: { unique: true },  comment: "師匠名"
      t.integer :users_count, null: false, index: false, default: 0, comment: "弟子数"
      t.timestamps
    end

    create_table :ppl_users, force: true do |t|
      t.belongs_to :rank,                 null: false, index: true,              comment: "種類"
      t.belongs_to :mentor,               null: true,  index: true,              comment: "師匠"

      t.string :name,                     null: false, index: { unique: true },  comment: "棋士名"
      t.integer :age_min,                 null: false, index: true,              comment: "リーグ入り年齢"
      t.integer :age_max,                 null: false, index: true,              comment: "リーグ最後の年齢"
      t.integer :runner_up_count,         null: true,  index: false,             comment: "次点個数"
      t.integer :win_max,                 null: true,  index: true,              comment: "最大勝ち数"

      t.float :win_ratio,                 null: true,  index: true,              comment: "勝率"

      t.belongs_to :promotion_membership, null: true,  index: true,              comment: "プロになったときの成績"
      t.integer :promotion_win,           null: true,  index: true,              comment: "プロになったときの勝ち数"
      t.integer :promotion_season_position, null: true, index: true,      comment: "プロになったときのシーズンの順序"

      t.belongs_to :memberships_first,    null: true,  index: true,              comment: "最初に参加したときの成績"

      t.belongs_to :memberships_last,     null: true,  index: true,              comment: "最後に参加したときの成績"

      t.belongs_to :deactivated_membership, null: true,  index: true,            comment: "退会時したときの成績"

      t.integer :memberships_count,       null: false, index: false, default: 0, comment: "参加期間相当"
      t.timestamps
    end

    create_table :ppl_seasons, force: true do |t|
      t.string :key,            null: false, index: true, comment: "キー (表示名)"
      t.integer :position,      null: true,  index: true, comment: "順序"
      t.timestamps
    end

    create_table :ppl_memberships, force: true do |t|
      t.belongs_to :season, null: false, index: true,  comment: "リーグ"
      t.belongs_to :user,          null: false, index: true,  comment: "棋士"
      t.belongs_to :result,        null: false, index: true,  comment: "結果"
      t.integer :age,              null: false, index: false, comment: "年齢"
      t.integer :win,              null: true,  index: true,  comment: "勝ち数"
      t.integer :lose,             null: true, index: false, comment: "負け数"
      t.string :ox,                null: false, index: false, comment: "勝敗"
      t.integer :ranking_pos,      null: true, index: false, comment: "最終順位"
      t.index [:season_id, :user_id], unique: true
      t.timestamps
    end

    create_table :ppl_results, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    create_table :ppl_ranks, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Ppl::Result.reset_column_information
    Ppl::Result.setup
    tp Ppl::Result

    Ppl::Rank.reset_column_information
    Ppl::Rank.setup
    tp Ppl::Rank
  end
end
