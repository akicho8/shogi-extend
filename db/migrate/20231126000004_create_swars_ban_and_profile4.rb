class CreateSwarsBanAndProfile4 < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_user_profiles, if_exists: true
    drop_table :url_handlings, if_exists: true

    change_column_null(:swars_users, :latest_battled_at, false)
    change_column_null(:swars_profiles, :ban_crawled_at, false)
  end
end
