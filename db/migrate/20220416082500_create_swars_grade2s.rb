class CreateSwarsGrade2s < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_grade2s rescue nil
    remove_column :swars_battles, :grade2_id rescue nil

    create_table :swars_grade2s, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Grade2.reset_column_information
    Swars::Grade2.setup
    grade2 = Swars::Grade2.fetch("通常")
    tp grade2

    change_table :swars_battles do |t|
      t.belongs_to :grade2, null: false, default: grade2.id, comment: "対局モード"
    end
  end
end
