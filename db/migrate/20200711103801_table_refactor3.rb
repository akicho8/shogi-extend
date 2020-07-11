class TableRefactor3 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_settings do |t|
      t.string :session_lock_token, null: true, comment: "複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン"
    end
  end
end
