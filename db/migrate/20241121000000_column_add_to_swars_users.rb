class ColumnAddToSwarsUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :swars_users do |t|
      t.datetime :soft_crawled_at, null: true, comment: "クロール(全体)"
      t.datetime :hard_crawled_at, null: true, comment: "クロール(1ページ目のみ)"
    end

    Swars::User.reset_column_information
    Swars::User.update_all("soft_crawled_at = latest_battled_at, hard_crawled_at = latest_battled_at")
  end

  def down
    remove_column :swars_users, :soft_crawled_at
    remove_column :swars_users, :hard_crawled_at
  end
end
