class AddSwarsMemberships1 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.integer :ek_score_without_cond, comment: "入玉宣言時の得点(仮)"
      t.integer :ek_score_with_cond, comment: "入玉宣言時の得点(条件考慮)"
    end

    Swars::Membership.reset_column_information
    Swars::Final.fetch("ENTERINGKING").battles.each(&:rebuild)
  end
end
