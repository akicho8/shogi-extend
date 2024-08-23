class CreateTransientAggregates < ActiveRecord::Migration[6.0]
  def up
    drop_table :swars_tag_judge2_items, if_exists: true
    drop_table :swars_tag_judge_items, if_exists: true
    drop_table :swars_transient_aggregates, if_exists: true
    drop_table :transient_aggregates, if_exists: true

    create_table :transient_aggregates, force: true do |t|
      t.string :group_name,    null: false, index: true,  comment: "スコープ"
      t.integer :generation,   null: false, index: true,  comment: "世代"
      t.json :aggregated_value, null: false, index: false, comment: "集計済みのデータ" # 最大 1G
      t.timestamps
    end

    add_index(:transient_aggregates, [:group_name, :generation], unique: true)

    # TransientAggregate.reset_column_information
    # TransientAggregate.set
  end
end
