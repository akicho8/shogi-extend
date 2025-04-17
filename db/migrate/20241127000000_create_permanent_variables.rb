# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Permanent variable (permanent_variables as PermanentVariable)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | value      | Value    | json        | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

class CreatePermanentVariables < ActiveRecord::Migration[6.0]
  def up
    create_table :permanent_variables, force: true do |t|
      t.string :key, null: false, index: { unique: true }, comment: "キー"
      t.json :value, null: false, index: false,            comment: "値" # 最大 1G
      t.timestamps
    end
  end
end
