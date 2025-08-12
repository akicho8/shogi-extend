class CreateTsl < ActiveRecord::Migration[6.0]
  def up
    create_table :tsl_users, force: true do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :min_age, comment: "リーグ入り年齢"
      t.integer :max_age, comment: "リーグ最後の年齢"
      t.integer :memberships_count, :default => 0
      t.integer :runner_up_count, null: false, comment: "次点個数"
      t.belongs_to :promotion_membership, index: true, comment: "プロになったときの成績"
      t.integer :promotion_generation, index: true, comment: "プロになった期"
      t.belongs_to :min_membership, index: true, comment: "最初に参加したときの成績"
      t.belongs_to :max_membership, index: true, comment: "最後に参加したときの成績"
      t.integer :min_generation, index: true, comment: "最初に参加したときの期"
      t.integer :max_generation, index: true, comment: "最後に参加したときの期"
      t.timestamps
    end

    create_table :tsl_leagues, force: true do |t|
      t.integer :generation, null: false, index: true
      t.timestamps
    end

    create_table :tsl_memberships, force: true do |t|
      t.belongs_to :league, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.belongs_to :result, null: false, index: true
      t.integer :start_pos, null: false, index: true, comment: "初期順位"
      t.integer :age, null: true
      t.integer :win, null: true, index: true
      t.integer :lose, null: true, index: true
      t.string :ox, null: false
      t.integer :previous_runner_up_count, index: true, null: false, comment: "これまでの次点回数"
      t.integer :seat_count, null: false, comment: "これまでの在籍数"
      t.index [:league_id, :user_id], unique: true
      t.timestamps
    end

    create_table :tsl_results, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Tsl::Result.reset_column_information
    Tsl::Result.setup
  end
end
