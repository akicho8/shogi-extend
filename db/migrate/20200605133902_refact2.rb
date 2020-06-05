class Refact2 < ActiveRecord::Migration[6.0]
  def change
    rename_table :colosseum_users, :users
    rename_table :colosseum_profiles, :profiles
    rename_table :colosseum_auth_infos, :auth_infos

    [:free_battles, :cpu_battle_records, :xy_records].each do |table|
      remove_index table, :colosseum_user_id
      rename_column table, :colosseum_user_id, :user_id
      add_index table, :user_id
    end

    ActiveStorage::Attachment.find_each do |e|
      e.record_type = e.record_type.remove("Colosseum::")
      e.save!
    end
  end
end
