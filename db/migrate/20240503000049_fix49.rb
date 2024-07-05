class Fix49 < ActiveRecord::Migration[6.0]
  def up
    remove_foreign_key :swars_memberships, :swars_battles, column: :battle_id, if_exists: true
    add_foreign_key :swars_memberships, :swars_battles, column: :battle_id
  end
end
