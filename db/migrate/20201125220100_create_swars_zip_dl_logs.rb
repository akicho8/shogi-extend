class CreateSwarsZipDlLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :swars_zip_dl_logs, force: true do |t|
      t.belongs_to :user,          null: false, foreign_key: true, comment: "登録者"
      t.belongs_to :swars_user,    null: false, foreign_key: true, comment: "対象者"
      t.string :query,             null: false,                    comment: "クエリ全体(予備)"
      t.integer :dl_count,         null: false,                    comment: "ダウンロード数(記録用)"
      t.datetime :begin_at,        null: false,                    comment: "スコープ(開始・記録用)"
      t.datetime :end_at,          null: false, index: true,       comment: "スコープ(終了)"
      t.timestamps                 null: false
    end
  end
end
