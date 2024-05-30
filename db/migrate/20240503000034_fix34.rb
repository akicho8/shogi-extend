class Fix34 < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_memberships do |t|
      t.float :ai_gear_freq, null: true, comment: "121頻出度"
    end
  end
end
