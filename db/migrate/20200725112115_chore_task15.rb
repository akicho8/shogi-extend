class ChoreTask15 < ActiveRecord::Migration[6.0]
  def up
    # c = ApplicationRecord.connection
    # c.execute("SET foreign_key_checks = 0")

    create_table :actb_emotion_folders, force: true do |t|
      t.string :key,       null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end
    create_table :actb_emotions, force: true do |t|
      t.belongs_to :user,     foreign_key: true,                              null: false, comment: "所有者"
      t.belongs_to :folder, foreign_key: { to_table: :actb_emotion_folders }, null: false, comment: "フォルダ"
      t.string :name,                                                         null: false, comment: "トリガー名"
      t.string :message,                                                      null: false, comment: "表示用伝言"
      t.string :voice,                                                        null: false, comment: "発声用文言"
      t.integer :position, null: false, index: true
      t.timestamps
    end

    # c.execute("SET foreign_key_checks = 1")
    # rescue Mysql2::Error => e
    # p e
  end
end
