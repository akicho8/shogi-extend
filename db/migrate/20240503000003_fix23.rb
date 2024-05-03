class Fix23 < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.integer :ai_wave_count, null: true, comment: "棋神使用模様個数"
    end
  end
end
