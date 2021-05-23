class Fix20 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.integer :obt_think_avg, null: true, comment: "開戦後の指し手の平均秒数"
      t.integer :obt_auto_max,  null: true, comment: "開戦後に1,2秒の指し手が続く最大"
    end
  end
end
