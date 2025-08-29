class CreateShareBoard1 < ActiveRecord::Migration[5.1]
  def up
    create_table :share_board_memberships, force: true do |t|
      t.belongs_to :battle,   null: false,              comment: "対局"
      t.belongs_to :user,     null: false,              comment: "対局者"
      t.belongs_to :judge,    null: false,              comment: "勝・敗・引き分け"
      t.belongs_to :location, null: false,              comment: "▲△"
      t.integer :position,    null: true,  index: true, comment: "順序"
      t.timestamps            null: false
    end

    create_table :share_board_users, force: true do |t|
      t.string :name, null: false, index: { unique: true }, comment: "対局者名"
      t.integer :memberships_count, :default => 0
      t.timestamps null: false
    end

    create_table :share_board_battles, force: true do |t|
      t.belongs_to :room,         null: false,                          comment: "部屋"
      t.string :key,              null: false, index: { unique: true }, comment: "対局識別子"
      t.string :title,            null: false,                          comment: "タイトル"
      t.text :sfen,               null: false, limit: 4096
      t.integer :turn,            null: false, index: true,             comment: "手数"
      t.belongs_to :win_location, null: false,                          comment: "勝利側"
      t.integer :position,        null: true,  index: true,             comment: "順序"
      t.timestamps                null: false
    end

    create_table :share_board_roomships, force: true do |t|
      t.belongs_to :room,       null: false, comment: "部屋"
      t.belongs_to :user,       null: false, comment: "対局者"
      t.integer :win_count,     null: false, index: true, comment: "勝数"
      t.integer :lose_count,    null: false, index: true, comment: "敗数"
      t.integer :battles_count, null: false, index: false, comment: "対局数"
      t.float :win_rate,        null: false, index: true, comment: "勝率"
      t.integer :score,         null: false, index: true, comment: "スコア"
      t.integer :rank,          null: false, index: true, comment: "順位"
      t.timestamps              null: false
    end

    create_table :share_board_rooms, force: true do |t|
      t.string :key,       null: false, index: { unique: true }, comment: "部屋識別子"
      t.integer :battles_count, :default => 0
      t.timestamps null: false
    end
  end
end
