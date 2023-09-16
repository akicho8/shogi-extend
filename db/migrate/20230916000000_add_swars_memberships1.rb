class AddSwarsMemberships1 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.integer :ek_score1, comment: "入玉宣言時の得点(仮)"
      t.integer :ek_score2, comment: "入玉宣言時の得点(条件考慮)"
    end
  end
end
