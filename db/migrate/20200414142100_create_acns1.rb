class CreateAcns1 < ActiveRecord::Migration[6.0]
  def change
    create_table :acns1_rooms do |t|
      t.timestamps
    end

    create_table :acns1_messages do |t|
      t.belongs_to :user
      t.belongs_to :room
      t.text :body
      t.timestamps
    end
  end
end
