require "#{__dir__}/setup"
# QuickScript::Swars::GradeBattleMiningScript.new.cache_write
# exit

user1 = Swars::User.create!(grade_key: "九段")
user2 = Swars::User.create!(grade_key: "八段")
battle = ::Swars::Battle.create_with_members!([user1, user2])
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
scope = Swars::Membership.where(id: ids)
QuickScript::Swars::GradeBattleMiningScript.new({}, {scope: scope, grade_keys: ["九段"], need_size: 1}).cache_write
QuickScript::Swars::GradeBattleMiningScript.new.aggregate[:"九段"] == [battle.id] # => true
# >> 2025-05-31 12:42:55 1/1 100.00 % T1 GradeBattleMiningScript 九段 win_only_conditon
# >> 2025-05-31T03:42:55.840Z pid=44446 tid=whi INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
