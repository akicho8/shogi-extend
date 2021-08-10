# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xconv record (xconv_records as XconvRecord)
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
# | created_at       | 作成日時         | datetime    | NOT NULL    |                            | G     |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |                            |       |
# |------------------+------------------+-------------+-------------+----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class CreateXconvRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :xconv_records, force: true do |t|
      t.belongs_to :user,           null: false,                                  comment: "対局者"
      t.belongs_to :recordable,     null: false, polymorphic: true,               comment: "対象レコード"
      t.text :convert_params,       null: false,                                  comment: "変換パラメータ"
      t.datetime :process_begin_at, null: true,                     index: true,  comment: "処理開始日時"
      t.datetime :process_end_at,   null: true,                     index: true,  comment: "処理終了日時"
      t.datetime :successed_at,     null: true,                     index: true,  comment: "成功日時"
      t.datetime :errored_at,       null: true,                     index: true,  comment: "エラー日時"
      t.text :error_message,        null: true,                                   comment: "エラーメッセージ"
      t.timestamps                  null: false
      t.index :created_at
    end
  end
end
