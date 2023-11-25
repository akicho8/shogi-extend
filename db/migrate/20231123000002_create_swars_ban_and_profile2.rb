class CreateSwarsBanAndProfile2 < ActiveRecord::Migration[5.1]
  def up
    change_table :swars_users do |t|
      t.datetime :latest_battled_at, null: true, comment: "直近の対局日時"
    end
  end
end
