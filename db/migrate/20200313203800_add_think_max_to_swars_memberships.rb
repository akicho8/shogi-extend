class AddThinkMaxToSwarsMemberships < ActiveRecord::Migration[5.2]
  def up
    [:swars_memberships].each do |table|
      change_table table do |t|
        t.integer :think_max
      end
    end

    Swars::Membership.reset_column_information
    Swars::Membership.update_all(think_max: 0)

    # [:swars_memberships].each do |table|
    #   change_table table do |t|
    #     t.change :think_max, :integer, null: false
    #     t.index :think_max
    #   end
    # end
  end

  def down
    # remove_index :swars_memberships, :think_max
    remove_column :swars_memberships, :think_max
  end
end
