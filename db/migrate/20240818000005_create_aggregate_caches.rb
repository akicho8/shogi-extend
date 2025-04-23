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
    drop_table :swars_tag_judge2_items, if_exists: true
    drop_table :swars_tag_judge_items,  if_exists: true
    drop_table :swars_aggregate_caches, if_exists: true
    drop_table :transient_aggregate,    if_exists: true
    drop_table :aggregate_caches,       if_exists: true

    create_table :aggregate_caches, force: true do |t|
      t.string :group_name,     null: false, index: true,  comment: "スコープ"
      t.integer :generation,    null: false, index: true,  comment: "世代"
      t.json :aggregated_value, null: false, index: false, comment: "集計済みデータ" # 最大 1G
      t.timestamps
    end

    add_index(:aggregate_caches, [:group_name, :generation], unique: true)

    AggregateCache.reset_column_information
    # QuickScript::Swars::GradeStatScript.primary_aggregate_call
    # QuickScript::Swars::TacticJudgeAggregator.new.cache_write
  end
end
