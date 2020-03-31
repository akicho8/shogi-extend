# frozen_string_literal: true

class AddThinkAvg3ToSwarsBattles < ActiveRecord::Migration[6.0]
  def change
    change_table :swars_memberships do |t|
      # t.belongs_to :opponent, index: {:unique => true}, null: true
      t.index [:battle_id, :op_user_id], unique: true, name: :memberships_bid_ouid
    end

    # Swars::Membership.reset_column_information
    # Swars::Membership.update_all(think_avg: 0)

    # [:swars_memberships].each do |table|
    #   change_table table do |t|
    #     t.change :think_avg, :integer, null: false
    #     t.index :think_avg
    #   end
    # end
  end
end
