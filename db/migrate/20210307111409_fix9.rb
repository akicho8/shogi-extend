class Fix9 < ActiveRecord::Migration[6.0]
  def change
    change_table :wkbk_moves_answers do |t|
      t.change :moves_str,       :text, limit: 1000, null: true, index: false
      t.change :moves_human_str, :text, limit: 1000, null: true, index: false
    end
  end
end
