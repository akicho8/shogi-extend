class AddDirectionMessageToQuestions < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.string :direction_message, null: true, comment: "クエスト指示文言またはヒント"
    end
  end
end
