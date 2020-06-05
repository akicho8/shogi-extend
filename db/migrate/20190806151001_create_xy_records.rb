# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------+-------------+-------------+-------------+--------------+-------|
# | name        | desc        | type        | opts        | refs         | index |
# |-------------+-------------+-------------+-------------+--------------+-------|
# | id          | ID          | integer(8)  | NOT NULL PK |              |       |
# | user_id     | User        | integer(8)  |             | => ::User#id | C     |
# | entry_name  | Entry name  | string(255) | NOT NULL    |              | A     |
# | summary     | Summary     | string(255) |             |              |       |
# | xy_rule_key | Xy rule key | string(255) | NOT NULL    |              | B     |
# | x_count     | X count     | integer(4)  | NOT NULL    |              |       |
# | spent_sec   | Spent sec   | float(24)   | NOT NULL    |              |       |
# | created_at  | 作成日時    | datetime    | NOT NULL    |              |       |
# | updated_at  | 更新日時    | datetime    | NOT NULL    |              |       |
# |-------------+-------------+-------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

class CreateXyRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :xy_records, force: true do |t|
      t.belongs_to :colosseum_user, null: true, index: true
      t.string :entry_name, index: true, null: false
      t.string :summary
      t.string :xy_rule_key, null: false, index: true
      t.integer :x_count, null: false
      t.float :spent_sec, null: false
      t.timestamps null: false
    end
  end
end
