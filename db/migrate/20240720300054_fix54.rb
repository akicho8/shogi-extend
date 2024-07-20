class Fix54 < ActiveRecord::Migration[6.0]
  def up
    remove_column :swars_memberships, :opponent_id

    change_table :swars_memberships do |t|
      t.belongs_to :opponent, null: true, index: { unique: true }, comment: "相手レコード"
    end
  end
end
