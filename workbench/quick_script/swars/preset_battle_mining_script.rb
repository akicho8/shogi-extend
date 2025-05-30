require "#{__dir__}/setup"
# QuickScript::Swars::PresetBattleMiningScript.new.cache_write
# exit

user1 = Swars::User.create!
user2 = Swars::User.create!
battle = ::Swars::Battle.create_with_members!([user1, user2])
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
scope = Swars::Membership.where(id: ids)
QuickScript::Swars::PresetBattleMiningScript.new({}, {scope: scope, need_size: 1}).cache_write
tp QuickScript::Swars::PresetBattleMiningScript.new.aggregate
QuickScript::Swars::PresetBattleMiningScript.new.aggregate[:"平手"] == [battle.id] # => true
# >> 2025-05-31 15:54:09 1/7  14.29 % T1 PresetBattleMiningScript 平手
# >> 2025-05-31 15:54:09 2/7  28.57 % T0 PresetBattleMiningScript 角落ち
# >> 2025-05-31 15:54:09 3/7  42.86 % T0 PresetBattleMiningScript 飛車落ち
# >> 2025-05-31 15:54:09 4/7  57.14 % T0 PresetBattleMiningScript 二枚落ち
# >> 2025-05-31 15:54:09 5/7  71.43 % T0 PresetBattleMiningScript 四枚落ち
# >> 2025-05-31 15:54:09 6/7  85.71 % T0 PresetBattleMiningScript 六枚落ち
# >> 2025-05-31 15:54:09 7/7 100.00 % T0 PresetBattleMiningScript 八枚落ち
# >> 2025-05-31T06:54:09.990Z pid=57860 tid=1alo INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |----------+------------|
# >> |     平手 | [61921179] |
# >> |   角落ち | []         |
# >> | 二枚落ち | []         |
# >> | 八枚落ち | []         |
# >> | 六枚落ち | []         |
# >> | 四枚落ち | []         |
# >> | 飛車落ち | []         |
# >> |----------+------------|
