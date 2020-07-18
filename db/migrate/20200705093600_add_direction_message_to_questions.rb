class AddDirectionMessageToQuestions < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.string :direction_message, null: true, comment: "メッセージ"
    end
  end
end
