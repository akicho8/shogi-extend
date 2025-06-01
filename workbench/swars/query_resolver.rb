require "#{__dir__}/setup"

user1 = Swars::User.create!(grade_key: "二段").tap(&:ban!)
user2 = Swars::User.create!(grade_key: "三段")

battles = []
battles << Swars::Battle.create_with_members!([user1, user2], { strike_plan: "嬉野流" })
membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [123251167, 123251168]
scope = Swars::Membership.where(id: membership_ids)
QuickScript::Swars::TacticBattleMiningScript.new({}, scope: scope, item_keys: ["嬉野流"]).cache_write
QuickScript::Swars::GradeBattleMiningScript.new({}, { scope: scope, grade_keys: ["二段"] }).cache_write
QuickScript::Swars::PresetBattleMiningScript.new({}, { scope: scope, preset_keys: ["平手"] }).cache_write
QuickScript::Swars::StyleBattleMiningScript.new({}, { scope: scope, style_keys: ["王道"] }).cache_write

Swars::QueryResolver.resolve(query_info: QueryInfo["初段"]).exists?                                           # => false
Swars::QueryResolver.resolve(query_info: QueryInfo["二段"]).exists?                                           # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["嬉野流"]).exists?                                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["平手"]).exists?                                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["王道"]).exists?                                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["id:#{battles.sole.id}"]).exists?                          # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["ids:#{battles.sole.id}"]).exists?                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["key:#{battles.sole.key}"]).exists?                        # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["keys:#{battles.sole.key}"]).exists?                       # => true
Swars::QueryResolver.resolve(params: { id: battles.sole.id }).exists?                                           # => true
Swars::QueryResolver.resolve(params: { ids: battles.sole.id }).exists?                                          # => true
Swars::QueryResolver.resolve(params: { key: battles.sole.key }).exists?                                         # => true
Swars::QueryResolver.resolve(params: { keys: battles.sole.key }).exists?                                        # => true
Swars::QueryResolver.resolve(params: { all: 1 }).exists?                                                        # => true
Swars::QueryResolver.resolve(params: { ban: 1 }).exists?                                                        # => true
Swars::QueryResolver.resolve(current_swars_user: user1, query_info: QueryInfo["嬉野流"]).exists? # => true

# >> 2025-06-01 16:31:03 1/1 100.00 % T1 TacticBattleMiningScript 嬉野流
# >> 2025-06-01T07:31:03.326Z pid=81303 tid=1oxr INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> 2025-06-01 16:31:03 1/1 100.00 % T1 GradeBattleMiningScript 二段
# >> 2025-06-01 16:31:03 1/1 100.00 % T1 PresetBattleMiningScript 平手
# >> 2025-06-01 16:31:03 1/1 100.00 % T1 StyleBattleMiningScript 王道
