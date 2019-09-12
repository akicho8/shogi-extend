class AddColumnTocolosseumTable1 < ActiveRecord::Migration[5.2]
  def change
    change_table :colosseum_users do |t|
      t.datetime :lobby_in_at, null: true, comment: "ロビーに入った時間"
    end
  end
end
