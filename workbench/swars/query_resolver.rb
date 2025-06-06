require "#{__dir__}/setup"
# Swars::QueryResolver.resolve(query_info: QueryInfo["abacus10"]) # => #<ActiveRecord::Relation []>
Swars::QueryResolver.resolve(query_info: QueryInfo["443443443"]) # => #<ActiveRecord::Relation []>
exit

user1 = Swars::User.create!(grade_key: "二段").tap(&:ban!)
user2 = Swars::User.create!(grade_key: "三段")

battles = []
battles << Swars::Battle.create_with_members!([user1, user2], { strike_plan: "嬉野流" })
membership_ids = battles.flat_map(&:memberships).collect(&:id) # =>
scope = Swars::Membership.where(id: membership_ids)
QuickScript::Swars::TacticBattleMiningScript.new({}, scope: scope, item_keys: ["嬉野流"]).cache_write
QuickScript::Swars::GradeBattleMiningScript.new({}, { scope: scope, grade_keys: ["二段"] }).cache_write
QuickScript::Swars::PresetBattleMiningScript.new({}, { scope: scope, preset_keys: ["平手"] }).cache_write
QuickScript::Swars::StyleBattleMiningScript.new({}, { scope: scope, style_keys: ["王道"] }).cache_write

Swars::QueryResolver.resolve(query_info: QueryInfo["初段"]).exists?                                           # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["二段"]).exists?                                           # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["嬉野流"]).exists?                                         # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["平手"]).exists?                                         # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["王道"]).exists?                                         # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["id:#{battles.sole.id}"]).exists?                          # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["ids:#{battles.sole.id}"]).exists?                         # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["key:#{battles.sole.key}"]).exists?                        # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["keys:#{battles.sole.key}"]).exists?                       # =>
Swars::QueryResolver.resolve(params: { id: battles.sole.id }).exists?                                           # =>
Swars::QueryResolver.resolve(params: { ids: battles.sole.id }).exists?                                          # =>
Swars::QueryResolver.resolve(params: { key: battles.sole.key }).exists?                                         # =>
Swars::QueryResolver.resolve(params: { keys: battles.sole.key }).exists?                                        # =>
Swars::QueryResolver.resolve(params: { all: 1 }).exists?                                                        # =>
Swars::QueryResolver.resolve(params: { ban: 1 }).exists?                                                        # =>
Swars::QueryResolver.resolve(current_swars_user: user1, query_info: QueryInfo["嬉野流"]).exists? # =>

Swars::User.find_by(key: "2024_0203")                                    # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["2024_0203"]).exists?                                           # =>


Swars::UserKeyValidator.valid?("443443443") # =>
Swars::UserKey["443443443"]                 # =>
Swars::User["443443443"]        # =>
Swars::User["443443443"].battles.count # =>
Swars::QueryResolver.resolve(query_info: QueryInfo["443443443"])
