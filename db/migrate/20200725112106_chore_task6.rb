class ChoreTask6 < ActiveRecord::Migration[6.0]
  def up
    create_table :mute_infos, force: true do |t|
      t.belongs_to :user,        foreign_key: { to_table: :users }, null: false, comment: "オーナー"
      t.belongs_to :target_user, foreign_key: { to_table: :users }, null: false, comment: "対象"
      t.timestamps
      t.index [:user_id, :target_user_id], unique: true
    end
  end
end
