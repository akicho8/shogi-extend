class AddGradeDiffToSwarsMemberships < ActiveRecord::Migration[5.2]
  def change
    [:swars_memberships].each do |table|
      change_table table do |t|
        t.integer :grade_diff
      end
    end

    Swars::Membership.reset_column_information
    Swars::Membership.update_all(grade_diff: 0)

    [:swars_memberships].each do |table|
      change_table table do |t|
        t.change :grade_diff, :integer, null: false
        t.index :grade_diff
      end
    end
  end
end
