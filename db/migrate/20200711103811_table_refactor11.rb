class TableRefactor11 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.integer :turn_max, null: true, index: true, comment: "最大手数"
    end

    Actb::Question.reset_column_information
    Actb::Question.find_each do |e|
      e.update!(turn_max: e.moves_answers.maximum("moves_count"))
    end
  end
end
