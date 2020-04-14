class CreateTsume < ActiveRecord::Migration[6.0]
  def change
    create_table :tsume_rooms do |t|
      t.timestamps
    end

    create_table :tsume_messages do |t|
      t.belongs_to :user
      t.belongs_to :room
      t.text :body
      t.timestamps
    end
  end
end
