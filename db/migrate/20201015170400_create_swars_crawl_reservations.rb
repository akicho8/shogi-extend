class CreateSwarsCrawlReservations < ActiveRecord::Migration[5.1]
  def change
    create_table :swars_crawl_reservations, force: true do |t|
      t.belongs_to :user,        null: false, foreign_key: true, comment: "登録者"
      t.string :target_user_key, null: false,                    comment: "対象者"
      t.string :to_email,        null: false,                    comment: "完了通知先メールアドレス"
      t.string :attachment_mode, null: false, index: true,       comment: "ZIPファイル添付の有無"
      t.datetime :processed_at,                                  comment: "処理完了日時"
      t.timestamps               null: false
    end
  end
end
