# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Alert log (alert_logs as AlertLog)
#
# |------------+----------+--------------+-------------+------+-------|
# | name       | desc     | type         | opts        | refs | index |
# |------------+----------+--------------+-------------+------+-------|
# | id         | ID       | integer(8)   | NOT NULL PK |      |       |
# | subject    | 件名     | string(255)  | NOT NULL    |      |       |
# | body       | 内容     | string(8192) | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime     | NOT NULL    |      |       |
# |------------+----------+--------------+-------------+------+-------|

class CreateAlertLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :alert_logs, force: true do |t|
      t.string :subject,      null: false
      t.string :body,         null: false, limit: 8192
      t.datetime :created_at, null: false
    end
  end
end
