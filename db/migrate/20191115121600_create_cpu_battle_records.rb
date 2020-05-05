# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Cpu battle record (cpu_battle_records as CpuBattleRecord)
#
# |-------------------+----------------+-------------+-------------+------+-------|
# | name              | desc           | type        | opts        | refs | index |
# |-------------------+----------------+-------------+-------------+------+-------|
# | id                | ID             | integer(8)  | NOT NULL PK |      |       |
# | colosseum_user_id | Colosseum user | integer(8)  |             |      | A     |
# | judge_key         | Judge key      | string(255) | NOT NULL    |      | B     |
# | created_at        | 作成日時       | datetime    | NOT NULL    |      |       |
# | updated_at        | 更新日時       | datetime    | NOT NULL    |      |       |
# |-------------------+----------------+-------------+-------------+------+-------|

class CreateCpuBattleRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :cpu_battle_records, force: true do |t|
      t.belongs_to :colosseum_user, null: true, index: true, comment: "ログインしているならそのユーザー"
      t.string :judge_key, comment: "結果", null: false, index: true
      t.timestamps null: false
    end
  end
end
