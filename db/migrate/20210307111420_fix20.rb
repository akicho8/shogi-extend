class Fix20 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.float :think_all_avg2,  null: true, comment: "開戦後の指し手の平均秒数"
      t.integer :two_serial_max2, null: true, comment: "開戦後の1または2秒の指し手が連続した回数"
      # t.integer :think_max2,       null: true, comment: "開戦後の最大考慮秒数"
    end
  end
end
