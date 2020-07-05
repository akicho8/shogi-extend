class AddQuestTitleToQuestions < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.string :quest_title, null: true
    end
  end
end
