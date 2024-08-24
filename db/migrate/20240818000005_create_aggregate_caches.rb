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
    # QuickScript::Swars::GradeStatScript.primary_aggregate_run
    # QuickScript::Swars::TacticStatScript.primary_aggregate_run
  end
end
