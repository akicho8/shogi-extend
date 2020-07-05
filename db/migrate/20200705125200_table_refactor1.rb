class TableRefactor1 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_questions do |t|
      t.rename :other_author, :source_author
    end
  end
end
