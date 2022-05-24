class SwarsRefactor1 < ActiveRecord::Migration[5.1]
  def up
    remove_column :swars_battles, :rule_key
    remove_column :swars_battles, :final_key
    remove_column :swars_battles, :preset_key
    remove_column :free_battles, :preset_key
    remove_column :swars_memberships, :location_key
    remove_column :swars_memberships, :judge_key

    change_column_default(:swars_battles, :xmode_id, nil)

    change_column_null(:swars_battles, :xmode_id, false)
    change_column_null(:swars_battles, :rule_id, false)
    change_column_null(:swars_battles, :final_id, false)
    change_column_null(:swars_battles, :preset_id, false)
    change_column_null(:swars_memberships, :location_id, false)
    change_column_null(:swars_memberships, :judge_id, false)

    change_table :swars_memberships do |t|
      t.remove_index(name: :memberships_sbri_lk)
    end

    change_table :swars_memberships do |t|
      t.index [:battle_id, :location_id], unique: true, name: :memberships_sbri_lk
    end
  end
end
