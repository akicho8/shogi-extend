class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    # ユーザー
    create_table :users, force: true do |t|
      t.string :key,                null: false, index: {unique: true}, comment: "キー"
      t.string :name,               null: false,              comment: "名前"
      t.string :cpu_brain_key,      null: true,               comment: "CPUだったときの挙動"
      t.string :user_agent,         null: false,              comment: "ブラウザ情報"
      t.string :race_key,           null: false, index: true, comment: "種族"
      t.datetime :name_input_at,    null: true
      t.timestamps                  null: false
    end

    # プロフィール
    create_table :profiles, force: true do |t|
      t.belongs_to :user,               null: false, index: {unique: true}, comment: "ユーザー"
      t.string :description,            null: false, limit: 512,            comment: "自己紹介"
      t.string :twitter_key,            null: false
      t.timestamps                      null: false
    end
  end
end
