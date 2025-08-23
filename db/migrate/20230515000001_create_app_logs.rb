# -*- coding: utf-8 -*-

# == Schema Information ==
#
# App log (app_logs as AppLog)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | level      | Level    | string(255) | NOT NULL    |      |       |
# | emoji      | Emoji    | string(255) | NOT NULL    |      |       |
# | subject    | 件名     | string(255) | NOT NULL    |      |       |
# | body       | 内容     | text(65535) | NOT NULL    |      |       |
# | process_id | Process  | integer(4)  | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      | A     |
# |------------+----------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add index] create_app_logs マイグレーションに add_index :app_logs, :process_id を追加してください
# [Warning: Need to add relation] AppLog モデルに belongs_to :process を追加してください
# --------------------------------------------------------------------------------

class CreateAppLogs < ActiveRecord::Migration[6.0]
  def up
    create_table :app_logs, force: true do |t|
      t.string :level,        null: false
      t.string :emoji,        null: false
      t.string :subject,      null: false
      t.text :body,           null: false
      t.integer :process_id,  null: false
      t.datetime :created_at, null: false
    end
  end
end
