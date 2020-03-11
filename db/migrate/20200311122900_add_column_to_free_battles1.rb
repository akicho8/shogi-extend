class AddColumnToFreeBattles1 < ActiveRecord::Migration[5.2]
  def up
    add_column :free_battles, :preset_key, :string rescue nil
    FreeBattle.reset_column_information
    FreeBattle.find_each(&:save!)
    change_column :free_battles, :preset_key, :string, index: true, null: false rescue nil
    FreeBattle.reset_column_information
  end

  def down
    remove_column :free_battles, :preset_key rescue nil
  end
end
