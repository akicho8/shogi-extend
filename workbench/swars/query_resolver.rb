require "#{__dir__}/setup"

current_swars_user = Swars::User.create!.tap(&:ban!)

battles = []
battles << Swars::Battle.create_with_members!([current_swars_user], {strike_plan: "嬉野流"})
membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [123251073, 123251074]
scope = Swars::Membership.where(id: membership_ids)
QuickScript::Swars::TacticBattleAggregator.new(scope: scope, item_keys: ["嬉野流"]).cache_write

Swars::QueryResolver.resolve(query_info: QueryInfo["嬉野流"]).exists?                                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["id:#{battles.sole.id}"]).exists?                          # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["ids:#{battles.sole.id}"]).exists?                         # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["key:#{battles.sole.key}"]).exists?                        # => true
Swars::QueryResolver.resolve(query_info: QueryInfo["keys:#{battles.sole.key}"]).exists?                       # => true
Swars::QueryResolver.resolve(params: {id: battles.sole.id}).exists?                                           # => true
Swars::QueryResolver.resolve(params: {ids: battles.sole.id}).exists?                                          # => true
Swars::QueryResolver.resolve(params: {key: battles.sole.key}).exists?                                         # => true
Swars::QueryResolver.resolve(params: {keys: battles.sole.key}).exists?                                        # => true
Swars::QueryResolver.resolve(params: {all: 1}).exists?                                                        # => true
Swars::QueryResolver.resolve(params: {ban: 1}).exists?                                                        # => true
Swars::QueryResolver.resolve(current_swars_user: current_swars_user, query_info: QueryInfo["嬉野流"]).exists? # => true

# >> 2025-05-27 14:07:10 1/9  11.11 % T1 TacticBattleAggregator 嬉野流
# >> 2025-05-27T05:07:11.024Z pid=44942 tid=wva INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
