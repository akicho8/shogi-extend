class AddSprintColumnsToSwarsV1 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_battles do |t|
      t.string :starting_position, comment: "初期配置"
    end
  end
end
