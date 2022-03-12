class Fix21 < ActiveRecord::Migration[5.1]
  def change
    change_table :swars_battles do |t|
      t.belongs_to :rule, null: false, comment: "ルール"
    end
  end
end
