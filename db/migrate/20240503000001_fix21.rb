class Fix21 < ActiveRecord::Migration[6.0]
  def change
    change_column_comment :swars_memberships, :obt_auto_max, from: "開戦後に1,2秒の指し手が続く最大", to: "棋神を使って指した総手数"
    change_table :swars_memberships do |t|
      if t.column_exists?(:obt_think_avg)
        t.remove :obt_think_avg
      end
    end
  end
end
