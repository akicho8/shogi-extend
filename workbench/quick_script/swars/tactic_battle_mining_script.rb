require "./setup"
# scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# tp QuickScript::Swars::TacticBattleMiningScript.new(scope: scope).tap(&:cache_write).aggregate

user1 = Swars::User.create!
user2 = Swars::User.create!
battle = ::Swars::Battle.create_with_members!([user1, user2], {strike_plan: "棒銀"})
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
scope = Swars::Membership.where(id: ids)
QuickScript::Swars::TacticBattleMiningScript.new({}, {scope: scope, item_keys: ["棒銀"], need_size: 1}).cache_write
tp QuickScript::Swars::TacticBattleMiningScript.new.aggregate

# >> 2025-05-31 15:57:14 1/1 100.00 % T1 TacticBattleMiningScript 棒銀
# >> 2025-05-31T06:57:14.449Z pid=58593 tid=1atl INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |------+------------|
# >> | 棒銀 | [61802214] |
# >> |------+------------|
