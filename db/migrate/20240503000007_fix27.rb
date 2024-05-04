class Fix27 < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_memberships do |t|
      t.integer :ai_noizy_two_max, null: true, comment: "22221パターンを考慮した2の並び個数最大値"
    end
  end
end
