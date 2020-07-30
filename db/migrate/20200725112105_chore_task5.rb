class ChoreTask5 < ActiveRecord::Migration[6.0]
  def up
    create_table :actb_notifications, force: true do |t|
      t.belongs_to :to_user,          foreign_key: { to_table: :users                  }, null: false, comment: "送信先"
      t.belongs_to :from_user,        foreign_key: { to_table: :users                  }, null: true,  comment: "送信元"
      t.belongs_to :question,         foreign_key: { to_table: :actb_questions         }, null: true,  comment: "問題"
      t.belongs_to :question_message, foreign_key: { to_table: :actb_question_messages }, null: true,  comment: "問題コメ"
      t.string     :title,                                                                null: true,  comment: "タイトル"
      t.string     :body, limit: 512,                                                     null: true,  comment: "本文"
      t.datetime   :opened_at,                                                            null: true,  comment: "開封日時"
      t.timestamps
    end
  end
end
