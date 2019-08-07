# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Xy record (xy_records as XyRecord)
#
# |-------------------+----------------+-------------+-------------+------+-------|
# | name              | desc           | type        | opts        | refs | index |
# |-------------------+----------------+-------------+-------------+------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |      |       |
# | name              | Name           | string(255) |             |      |       |
# | summary           | Summary        | string(255) |             |      |       |
# | xy_rule_key          | Rule key       | string(255) |             |      |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             |      | A     |
# | o_count_max       | O count max    | integer(4)  |             |      |       |
# | o_count           | O count        | integer(4)  |             |      |       |
# | x_count           | X count        | integer(4)  |             |      |       |
# | spent_msec        | Spent msec     | float(24)   |             |      |       |
# | created_at        | 作成日時       | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |      |       |
# |-------------------+----------------+-------------+-------------+------+-------|
#
#- Remarks ----------------------------------------------------------------------
# [Warning: Need to add relation] XyRecord モデルに belongs_to :colosseum_user を追加してください
#--------------------------------------------------------------------------------

class CreateXyRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :xy_records, force: true do |t|
      t.belongs_to :colosseum_user, null: true, index: true
      t.string :entry_name
      t.string :summary
      t.string :xy_rule_key
      t.integer :x_count
      t.float :spent_msec
      t.timestamps null: false
    end
  end
end
