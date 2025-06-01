require "#{__dir__}/setup"

# puts QuickScript::Swars::StyleBattleMiningScript.ancestors # => nil
# exit

# QuickScript::Swars::StyleBattleMiningScript.new.cache_write
# exit

user1 = Swars::User.create!
user2 = Swars::User.create!
battle = ::Swars::Battle.create_with_members!([user1, user2])
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
scope = Swars::Membership.where(id: ids)
QuickScript::Swars::StyleBattleMiningScript.new({}, {scope: scope, need_size: 1}).cache_write
tp QuickScript::Swars::StyleBattleMiningScript.new.aggregate
QuickScript::Swars::StyleBattleMiningScript.new.aggregate[:"王道"] == [battle.id] # => true

# >> 2025-06-01 16:57:05 1/4  25.00 % T1 StyleBattleMiningScript 王道
# >> 2025-06-01 16:57:05 2/4  50.00 % T0 StyleBattleMiningScript 準王道
# >> 2025-06-01 16:57:05 3/4  75.00 % T0 StyleBattleMiningScript 準変態
# >> 2025-06-01 16:57:05 4/4 100.00 % T0 StyleBattleMiningScript 変態
# >> 2025-06-01T07:57:05.958Z pid=84930 tid=1rmy INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |--------+------------|
# >> |   変態 | []         |
# >> |   王道 | [61921192] |
# >> | 準変態 | []         |
# >> | 準王道 | [61921192] |
# >> |--------+------------|
