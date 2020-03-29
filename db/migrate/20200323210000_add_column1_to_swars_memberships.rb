class AddColumn1ToSwarsMemberships < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      t.belongs_to :op_user, index: true, comment: "相手"
    end
  end
end
