require "./setup"
Swars::ZipDlLog.destroy_all
User.admin.swars_zip_dl_logs.destroy_all
exit
# QuickScript::Swars::BattleDownloadScript.new({}, {current_user: User.admin}).oldest_log_create
# exit
# User.admin = User.create!(email: "pinpon.ikeda+#{SecureRandom.hex}@gmail.com", confirmed_at: Time.current) # =>
# User.admin.swars_zip_dl_logs.count   # =>

user1 = Swars::User.create!
swars_user_key = user1.key      # => 
swars_battle_key = Swars::BattleKeyGenerator.new(seed: Swars::Battle.count).generate.to_s
battle = Swars::Battle.create!(key: swars_battle_key) do |e|
  e.memberships.build(user: user1)
end
battle                          # => 

instance = QuickScript::Swars::BattleDownloadScript.new({swars_user_key: swars_user_key, scope_key: "recent", max_key: "200"}, {current_user: User.admin, background_mode: true})
instance.dl_rest_count          # => 
instance.call                   # => 
instance.download_content.size  # => 
instance.download_filename      # => 
instance.dl_rest_count          # => 
