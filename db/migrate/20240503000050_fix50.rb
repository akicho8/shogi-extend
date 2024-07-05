class Fix50 < ActiveRecord::Migration[6.0]
  def up
    tp Swars::Membership.where.missing(:battle).count
    Swars::Membership.where.missing(:battle).find_each { |e| p e.id; e.destroy! }
    remove_foreign_key :swars_memberships, :swars_battles, column: :battle_id, if_exists: true
    add_foreign_key :swars_memberships, :swars_battles, column: :battle_id
    tp Swars::Membership.where.missing(:battle).count
  end
end
