# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (time_records as TimeRecord)
#
# |-------------+-------------+-------------+-------------+--------------+-------|
# | name        | desc        | type        | opts        | refs         | index |
# |-------------+-------------+-------------+-------------+--------------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User        | integer(8)  |             | => ::User#id | A     |
# | entry_name  | Entry name  | string(255) | NOT NULL    |              | B     |
# | summary     | Summary     | string(255) |             |              |       |
# | rule_key | Xy rule key | string(255) | NOT NULL    |              | C     |
# | x_count     | X count     | integer(4)  | NOT NULL    |              |       |
# | spent_sec   | Spent sec   | float(24)   | NOT NULL    |              |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |              |       |
# |-------------+-------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class CreateXyMaster < ActiveRecord::Migration[5.1]
  def change
    create_table :time_records, force: true do |t|
      t.belongs_to :user,    null: true
      t.string :entry_name,  null: false, index: true
      t.string :summary,     null: true
      t.string :rule_key, null: false, index: true
      t.integer :x_count,    null: false
      t.float :spent_sec,    null: false
      t.timestamps           null: false
    end
  end
end
