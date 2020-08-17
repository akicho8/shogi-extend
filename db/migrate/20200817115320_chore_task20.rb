class ChoreTask20 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_histories do |t|
      t.belongs_to :room, foreign_key: {to_table: :actb_rooms}, null: true, comment: "対戦部屋"
    end
  end
end
