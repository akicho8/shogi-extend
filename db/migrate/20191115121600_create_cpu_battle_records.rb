# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Cpu battle record (cpu_battle_records as CpuBattleRecord)
#
# |------------+-----------+-------------+-------------+--------------+-------|
# | name       | desc      | type        | opts        | refs         | index |
# |------------+-----------+-------------+-------------+--------------+-------|
# | id         | ID        | integer(8)  | NOT NULL PK |              |       |
# | user_id    | User      | integer(8)  |             | => ::User#id | B     |
# | judge_key  | Judge key | string(255) | NOT NULL    |              | A     |
# | created_at | 作成日時  | datetime    | NOT NULL    |              |       |
# | updated_at | 更新日時  | datetime    | NOT NULL    |              |       |
# |------------+-----------+-------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

class CreateCpuBattleRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :cpu_battle_records, force: true do |t|
      t.belongs_to :user,  null: true,  index: true, comment: "ログインしているならそのユーザー"
      t.string :judge_key, null: false, index: true, comment: "結果"
      t.timestamps         null: false
    end
  end
end
