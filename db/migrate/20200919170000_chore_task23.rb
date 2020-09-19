class ChoreTask23 < ActiveRecord::Migration[6.0]
  def up
    change_table :tsl_users do |t|
      t.remove :break_through_p
      t.integer :break_through_generation, index: true, null: true, comment: "プロになったか？"
    end
  end
end
