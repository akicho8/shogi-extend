# frozen_string_literal: true

class AddThinkAvg2ToSwarsBattles < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_memberships do |t|
      t.integer :two_serial_max
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

  def down
    # remove_index :swars_memberships, :think_avg
    remove_column :swars_memberships, :two_serial_max
  end
end
