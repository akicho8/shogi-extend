class CreateThreeStageLeague < ActiveRecord::Migration[6.0]
  def up
    create_table :tsl_users do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :first_age, comment: "リーグ入り年齢"
      t.integer :last_age, comment: "リーグ最後の年齢"
      t.integer :memberships_count, :default => 0
      t.timestamps
    end
    create_table :tsl_leagues do |t|
      t.integer :generation, null: false, index: true
      t.timestamps
    end
    create_table :tsl_memberships do |t|
      t.belongs_to :league, null: false, index: true
      t.belongs_to :user, null: false, index: true
      t.string :result_key, null: false, index: true, comment: "結果"
      t.integer :start_pos, null: false, index: true, comment: "初期順位"
      t.integer :age
      t.integer :win, null: true, index: true
      t.integer :lose, null: true, index: true
      t.index [:league_id, :user_id], unique: true
      t.string :ox, null: false
      t.timestamps
    end
  end
  def down
    drop_table :tsl_users rescue nil
    drop_table :tsl_leagues rescue nil
    drop_table :tsl_memberships rescue nil
  end
end
