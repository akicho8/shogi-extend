class CreateFreeBattles < ActiveRecord::Migration[5.1]
  def up
    create_table :free_battles, force: true do |t|
      t.string :key,            null: false, index: {unique: true}, charset: 'utf8', collation: 'utf8_bin', comment: "URL識別子"
      t.string :kifu_url,       null: true,                                                                 comment: "入力した棋譜URL"
      t.string :title,          null: true
      t.text :kifu_body,        null: false, limit: 16777215,                                               comment: "棋譜本文"
      t.integer :turn_max,      null: false, index: true,                                                   comment: "手数"
      t.text :meta_info,        null: false,                                                                comment: "棋譜メタ情報"
      t.datetime :battled_at,   null: false, index: true,                                                   comment: "対局開始日時"
      t.string :use_key,        null: false, index: true
      t.datetime :accessed_at,  null: false,                                                                comment: "最終参照日時"
      t.belongs_to :user,       null: true, index: true
      t.string :preset_key,     null: false, index: true
      t.text :description,      null: false
      t.string :sfen_body,      null: false, limit: 8192
      t.string :sfen_hash,      null: false

      t.integer :start_turn,    null: true, index: true, comment: "???"
      t.integer :critical_turn, null: true, index: true, comment: "開戦"
      t.integer :outbreak_turn, null: true, index: true, comment: "中盤"
      t.integer :image_turn,    null: true,              comment: "???"
    end
  end
end
