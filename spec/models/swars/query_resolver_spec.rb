require "rails_helper"

RSpec.describe Swars::QueryResolver, type: :model, swars_spec: true do
  it "works" do
    current_swars_user = Swars::User.create!.tap(&:ban!)

    battles = []
    battles << Swars::Battle.create_with_members!([current_swars_user], {strike_plan: "嬉野流"})
    membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [1, 2]
    scope = Swars::Membership.where(id: membership_ids)
    QuickScript::Swars::TacticBattleAggregator.new(scope: scope, item_keys: ["嬉野流"]).cache_write

    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("嬉野流")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("id:#{battles.sole.id}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("ids:#{battles.sole.id}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("key:#{battles.sole.key}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("keys:#{battles.sole.key}")).exists? }
    assert { Swars::QueryResolver.resolve(params: {id: battles.sole.id}).exists? }
    assert { Swars::QueryResolver.resolve(params: {ids: battles.sole.id}).exists? }
    assert { Swars::QueryResolver.resolve(params: {key: battles.sole.key}).exists? }
    assert { Swars::QueryResolver.resolve(params: {keys: battles.sole.key}).exists? }
    assert { Swars::QueryResolver.resolve(params: {all: 1}).exists? }
    assert { Swars::QueryResolver.resolve(params: {ban: 1}).exists? }
    assert { Swars::QueryResolver.resolve(current_swars_user: current_swars_user, query_info: QueryInfo.parse("嬉野流")).exists? }
  end
end
# >> Run options: exclude {chat_gpt_spec: true, login_spec: true, slow_spec: true}
# >> 
# >> Swars::QueryResolver
# >> 1999-12-31T15:00:00.000Z pid=44735 tid=whz INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >>   works
# >> 
# >> Top 1 slowest examples (0.83425 seconds, 25.0% of total time):
# >>   Swars::QueryResolver works
# >>     0.83425 seconds -:4
# >> 
# >> Finished in 3.33 seconds (files took 1.45 seconds to load)
# >> 1 example, 0 failures
# >> 
