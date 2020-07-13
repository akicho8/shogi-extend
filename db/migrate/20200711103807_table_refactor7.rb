class TableRefactor7 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_rooms do |t|
      t.belongs_to :bot_user, foreign_key: {to_table: :users}, null: true, comment: "練習相手"
    end
  end
end
