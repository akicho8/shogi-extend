class CreateTsl < ActiveRecord::Migration[6.0]
  def up
    create_table :tsl_users, force: true do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :first_age, comment: "リーグ入り年齢"
      t.integer :last_age, comment: "リーグ最後の年齢"
      t.integer :memberships_count, :default => 0
      t.integer :runner_up_count, null: false, comment: "次点個数"
      t.integer :level_up_generation, index: true, comment: "プロになった世代"
      t.timestamps
    end
    create_table :tsl_leagues, force: true do |t|
      t.integer :generation, null: false, index: true
      t.timestamps
    end
    create_table :tsl_memberships, force: true do |t|
      t.belongs_to :league, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.string :result_key, null: false, index: true, comment: "結果"
      t.integer :start_pos, null: false, index: true, comment: "初期順位"
      t.integer :age
      t.integer :win, null: true, index: true
      t.integer :lose, null: true, index: true
      t.string :ox, null: false
      t.integer :previous_runner_up_count, index: true, null: false, comment: "これまでの次点回数"
      t.integer :seat_count, null: false, comment: "これまでの在籍数"
      t.index [:league_id, :user_id], unique: true
      t.timestamps
    end
  end
end
