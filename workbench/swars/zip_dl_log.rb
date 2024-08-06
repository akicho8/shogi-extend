require "./setup"

Timecop.freeze("2000-01-01")

current_user = User.create!
swars_user = Swars::User.create!
Swars::Battle.create! do |e|
  e.memberships.build(user: swars_user)
end
current_user.swars_zip_dl_logs.destroy_all
current_user.swars_zip_dl_logs.where(swars_user: swars_user).create_by_battles!(swars_user.battles.limit(1))
current_user.swars_zip_dl_logs.count # => 1
current_user.swars_zip_dl_logs.recent_dl_total    # => 1
current_user.swars_zip_dl_logs.download_prohibit?             # => false
current_user.swars_zip_dl_logs.continue_begin_at == "2000-01-01 00:00:01".to_time # => true

current_user.swars_zip_dl_logs.recent_only.count # => 1
Timecop.freeze("2000-01-02")
current_user.swars_zip_dl_logs.recent_only.count # => 0
