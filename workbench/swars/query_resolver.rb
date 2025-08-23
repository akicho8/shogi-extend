require "#{__dir__}/setup"
# Swars::QueryResolver.resolve(query_info: QueryInfo["abacus10"]) # => #<ActiveRecord::Relation []>
# Swars::QueryResolver.resolve(query_info: QueryInfo["443443443"]) # => #<ActiveRecord::Relation []>
# exit

user1 = Swars::User.create!(grade_key: "二段").tap(&:ban!)
user2 = Swars::User.create!(grade_key: "三段")

battles = []
battles << Swars::Battle.create_with_members!([user1, user2], { strike_plan: "四間飛車" })
membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [117, 118]
scope = Swars::Membership.where(id: membership_ids)
QuickScript::Swars::TacticBattleMiningScript.new({}, scope: scope, item_keys: ["四間飛車"]).cache_write
QuickScript::Swars::GradeBattleMiningScript.new({}, { scope: scope, grade_keys: ["二段"] }).cache_write
QuickScript::Swars::PresetBattleMiningScript.new({}, { scope: scope, preset_keys: ["平手"] }).cache_write
QuickScript::Swars::StyleBattleMiningScript.new({}, { scope: scope, style_keys: ["王道"] }).cache_write

Swars::QueryResolver.resolve(query_info: QueryInfo["初段"]).exists?                              # => false
Swars::QueryResolver.resolve(query_info: QueryInfo["二段"]).exists?                              # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["四間飛車"]).exists?                          # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["平手"]).exists?                              # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["王道"]).exists?                              # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["id:#{battles.sole.id}"]).exists?             # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["ids:#{battles.sole.id}"]).exists?            # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["key:#{battles.sole.key}"]).exists?           # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["keys:#{battles.sole.key}"]).exists?          # => true
Swars::QueryResolver.resolve(params: { id: battles.sole.id }).exists?                            # => true
Swars::QueryResolver.resolve(params: { ids: battles.sole.id }).exists?                           # => true
Swars::QueryResolver.resolve(params: { key: battles.sole.key }).exists?                          # => true
Swars::QueryResolver.resolve(params: { keys: battles.sole.key }).exists?                         # => true
Swars::QueryResolver.resolve(params: { all: 1 }).exists?                                         # => true
Swars::QueryResolver.resolve(params: { ban: 1 }).exists?                                         # => true
Swars::QueryResolver.resolve(current_swars_user: user1, query_info: QueryInfo["四間飛車"]).exists? # => true

Swars::User.find_by(key: "2024_0203")                                    # => nil
Swars::QueryResolver.resolve(query_info: QueryInfo["2024_0203"]).exists?                                           # => false

Swars::UserKeyValidator.valid?("443443443") # => true
Swars::UserKey["443443443"]                 # => <443443443>
Swars::User["443443443"]        # => nil
Swars::User["443443443"].battles.count # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["443443443"])
# ~> -:41:in '<main>': undefined method 'battles' for nil (NoMethodError)
# >> 2025-08-10 11:53:41 1/1 100.00 % T1 TacticBattleMiningScript 四間飛車
# >> 2025-08-10T02:53:41.288Z pid=64338 tid=1bxe INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> 2025-08-10 11:53:41 1/1 100.00 % T1 GradeBattleMiningScript 二段
# >> 2025-08-10 11:53:41 1/1 100.00 % T1 PresetBattleMiningScript 平手
# >> 2025-08-10 11:53:41 1/1 100.00 % T1 StyleBattleMiningScript 王道
