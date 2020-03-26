# frozen_string_literal: true

class AddThinkLastToSwarsBattles < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_memberships do |t|
      t.integer :think_last
    end

    Swars::Membership.reset_column_information
    Swars::Membership.update_all(think_last: 0)

    # [:swars_memberships].each do |table|
    #   change_table table do |t|
    #     t.change :think_last, :integer, null: false
    #     t.index :think_last
    #   end
    # end
  end

  def down
    # remove_index :swars_memberships, :think_last
    remove_column :swars_memberships, :think_last
  end
end
