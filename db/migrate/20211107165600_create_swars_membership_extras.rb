class CreateSwarsMembershipExtras < ActiveRecord::Migration[6.0]
  def change
    create_table :swars_membership_extras, force: true do |t|
      t.belongs_to :membership, null: false, index: { unique: true }, comment: "対局情報"
      t.json :used_piece_counts, null: false,  comment: "駒の使用頻度"
      t.timestamps null: false
    end
  end
end
