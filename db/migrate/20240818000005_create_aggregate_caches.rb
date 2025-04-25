# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Aggregate cache (aggregate_caches as AggregateCache)
#
# |------------------+------------------+-------------+-------------+------+-------|
# | name             | desc             | type        | opts        | refs | index |
# |------------------+------------------+-------------+-------------+------+-------|
# | id               | ID               | integer(8)  | NOT NULL PK |      |       |
# | group_name       | Group name       | string(255) | NOT NULL    |      | A! B  |
# | generation       | Generation       | integer(4)  | NOT NULL    |      | A! C  |
# | aggregated_value | Aggregated value | json        | NOT NULL    |      |       |
# | created_at       | 作成日時         | datetime    | NOT NULL    |      |       |
# | updated_at       | 更新日時         | datetime    | NOT NULL    |      |       |
# |------------------+------------------+-------------+-------------+------+-------|

class CreateAggregateCaches < ActiveRecord::Migration[6.0]
  def up
    create_table :aggregate_caches, force: true do |t|
      t.string :group_name,     null: false, index: true,  comment: "スコープ"
      t.integer :generation,    null: false, index: true,  comment: "世代"
      t.json :aggregated_value, null: false, index: false, comment: "集計済みデータ" # 最大 1G
      t.timestamps
    end

    add_index(:aggregate_caches, [:group_name, :generation], unique: true)
  end
end
