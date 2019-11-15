class CreateCpuBattleRecords < ActiveRecord::Migration[5.1]
  def up
    create_table :cpu_battle_records, force: true do |t|
      t.belongs_to :colosseum_user, null: true, index: true, comment: "ログインしているならそのユーザー"
      t.string :judge_key, comment: "結果", null: false, index: true
      t.timestamps null: false
    end
  end
end
