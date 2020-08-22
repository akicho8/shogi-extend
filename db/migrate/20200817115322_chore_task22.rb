class ChoreTask22 < ActiveRecord::Migration[6.0]
  def up
    create_table :actb_vs_records, force: true do |t|
      t.belongs_to :battle, foreign_key: {to_table: :actb_battles},    null: false, comment: "対戦"
      t.string :sfen_body, limit: 1536, null: false, index: false,                  comment: "棋譜"
      t.timestamps
    end
  end
end
