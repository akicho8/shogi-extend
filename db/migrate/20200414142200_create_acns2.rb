class CreateAcns2 < ActiveRecord::Migration[6.0]
  def change
    create_table :acns2_rooms do |t|
      t.timestamps
    end

    create_table :acns2_memberships do |t|
      t.belongs_to :room, null: false, comment: "対局部屋"
      t.belongs_to :user, null: false, comment: "対局者"
      t.string :judge_key, null: false, index: true, comment: "勝・敗・引き分け"
      t.integer :rensho_count, null: false, index: true, comment: "連勝数"
      t.integer :renpai_count, null: false, index: true, comment: "連敗数"
      t.integer :position, index: true, comment: "順序"
      t.timestamps null: false

      t.index [:room_id, :user_id], unique: true
    end

    create_table :acns2_messages do |t|
      t.belongs_to :user
      t.belongs_to :room
      t.text :body
      t.timestamps null: false
    end
  end
end
