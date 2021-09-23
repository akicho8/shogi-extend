# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Kiwi record (lemons as Kiwi::Lemon)
#
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | name             | desc             | type        | opts        | refs                       | index |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |                            |       |
# | user_id          | User             | integer(8)  | NOT NULL    | => User#id                 | A     |
# | recordable_type  | Recordable type  | string(255) | NOT NULL    | SpecificModel(polymorphic) | B     |
# | recordable_id    | Recordable       | integer(8)  | NOT NULL    | => (recordable_type)#id    | B     |
# | convert_params   | Convert params   | text(65535) | NOT NULL    |                            |       |
# | process_begin_at | Process begin at | datetime    |             |                            | C     |
# | process_end_at   | Process end at   | datetime    |             |                            | D     |
# | successed_at     | Successed at     | datetime    |             |                            | E     |
# | errored_at       | Errored at       | datetime    |             |                            | F     |
# | error_message    | Error message    | text(65535) |             |                            |       |
# | file_size        | File size        | integer(4)  |             |                            |       |
# | ffprobe_info     | Ffprobe info     | text(65535) |             |                            |       |
# | browser_path     | Browser path     | string(255) |             |                            |       |
# | filename_human   | Filename human   | string(255) |             |                            |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class CreateKiwi < ActiveRecord::Migration[6.0]
  def change
    DbCop.foreign_key_checks_disable do
      create_table :kiwi_lemons, force: true do |t|
        t.belongs_to :user,           null: false, foreign_key: true, comment: "所有者"
        t.belongs_to :recordable,     null: false, polymorphic: true, comment: "対象レコード"
        t.text :convert_params,       null: false,                    comment: "変換パラメータ"
        t.datetime :process_begin_at, null: true, index: true,        comment: "処理開始日時"
        t.datetime :process_end_at,   null: true, index: true,        comment: "処理終了日時"
        t.datetime :successed_at,     null: true, index: true,        comment: "成功日時"
        t.datetime :errored_at,       null: true, index: true,        comment: "エラー日時"
        t.text :error_message,        null: true,                     comment: "エラーメッセージ"
        t.integer :file_size,         null: true,                     comment: "ファイルサイズ"
        t.text :ffprobe_info,         null: true,                     comment: "変換パラメータ"
        t.string :browser_path,       null: true,                     comment: "生成したファイルへのパス"
        t.string :filename_human,     null: true,                     comment: "ダウンロードファイル名"

        t.string     :key,                          null: false, index: { unique: true }
        t.string     :title,       limit: 100,      null: false, comment: "タイトル"
        t.text       :description, limit: 5000,     null: false, comment: "説明"

        t.timestamps                  null: false
        t.index :created_at
      end
    end
  end
end
