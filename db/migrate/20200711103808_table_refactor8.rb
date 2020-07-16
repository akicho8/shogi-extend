class TableRefactor8 < ActiveRecord::Migration[6.0]
  def up
    create_table :actb_source_abouts, force: true do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end

    change_table :actb_questions do |t|
      t.belongs_to :source_about, foreign_key: {to_table: :actb_source_abouts}, null: true, comment: "所在"
    end
  end
end
