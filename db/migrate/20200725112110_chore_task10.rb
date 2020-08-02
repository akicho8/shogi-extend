class ChoreTask10 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.boolean :mate_skip, comment: "詰みチェックをスキップする"
    end
  end
end
