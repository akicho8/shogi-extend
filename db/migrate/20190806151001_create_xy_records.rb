# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | name              | desc           | type        | opts        | refs                        | index |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |                             |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             | :user => Colosseum::User#id | A     |
# | entry_name        | Entry name     | string(255) |             |                             |       |
# | summary           | Summary        | string(255) |             |                             |       |
# | xy_rule_key       | Xy rule key    | string(255) |             |                             |       |
# | x_count           | X count        | integer(4)  |             |                             |       |
# | spent_msec        | Spent msec     | float(24)   |             |                             |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |                             |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |                             |       |
# |-------------------+----------------+-------------+-------------+-----------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

class CreateXyRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :xy_records, force: true do |t|
      t.belongs_to :colosseum_user, null: true, index: true
      t.string :entry_name
      t.string :summary
      t.string :xy_rule_key, null: false, index: true
      t.integer :x_count, null: false
      t.float :spent_msec, null: false
      t.timestamps null: false
    end
  end
end
