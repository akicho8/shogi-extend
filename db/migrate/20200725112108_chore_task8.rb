class ChoreTask8 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_notifications do |t|
      t.remove :from_user_id
      t.remove :title
      t.remove :body
      t.remove :question_id
    end

    create_table :actb_notifications, force: true do |t|
      t.belongs_to :question_message, foreign_key: { to_table: :actb_question_messages }, null: false, comment: "問題コメント"
      t.belongs_to :user,             foreign_key: { to_table: :users                  }, null: false, comment: "通知先"
      t.datetime   :opened_at,                                                            null: true,  comment: "開封日時"
      t.timestamps
    end
  end
end
