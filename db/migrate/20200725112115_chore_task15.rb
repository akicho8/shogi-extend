class ChoreTask15 < ActiveRecord::Migration[6.0]
  def change
    # c = ApplicationRecord.connection
    # c.execute("SET foreign_key_checks = 0")

    create_table :actb_emotion_categories, force: true do |t|
      t.string :key,       null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end
    create_table :actb_emotions, force: true do |t|
      t.belongs_to :user,     foreign_key: true,                                   null: false
      t.belongs_to :category, foreign_key: { to_table: :actb_emotion_categories }, null: false
      t.string :name,                                                              null: false
      t.string :message,                                                           null: false
      t.string :voice,                                                               null: false
      t.timestamps
    end

    # c.execute("SET foreign_key_checks = 1")
  end
end
