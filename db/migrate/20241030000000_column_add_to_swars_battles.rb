class ColumnAddToSwarsBattles < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_battles do |t|
      t.integer :analysis_version, null: false, default: 0, comment: "戦法解析バージョン"
    end
  end
end
