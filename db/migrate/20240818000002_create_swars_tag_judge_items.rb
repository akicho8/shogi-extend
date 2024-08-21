class CreateSwarsTagJudgeItems < ActiveRecord::Migration[6.0]
  def change
    drop_table :swars_tag_tsuyosa_items, if_exists: true

    create_table :swars_tag_judge_items, force: true do |t|
      t.integer :generation, null: false, index: true,  comment: "世代"
      t.string :tag_name,    null: false, index: true,  comment: "タグ名"
      t.integer :win_count,  null: false, index: false, comment: "勝数"
      t.integer :lose_count, null: false, index: false, comment: "敗数"
      t.integer :draw_count, null: false, index: false, comment: "引き分け数"
      t.integer :freq_count, null: false, index: false, comment: "総数"
      t.timestamps
    end

    add_index(:swars_tag_judge_items, [:generation, :tag_name], unique: true)

    Swars::TagJudgeItem.reset_column_information
    Swars::TagJudgeItem.create_new_generation_items
  end
end
