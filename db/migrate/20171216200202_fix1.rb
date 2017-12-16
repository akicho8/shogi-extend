class Fix1 < ActiveRecord::Migration[5.1]
  def up
    rename_table :battle_ranks, :battle_grades
    rename_column :battle_ships, :battle_rank_id, :battle_grade_id
    rename_column :battle_users, :battle_rank_id, :battle_grade_id
  end
end
