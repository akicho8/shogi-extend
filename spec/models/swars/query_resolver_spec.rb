require "rails_helper"

RSpec.describe Swars::QueryResolver, type: :model, swars_spec: true do
  it "works" do
    user1 = Swars::User.create!(grade_key: "二段").tap(&:ban!)
    user2 = Swars::User.create!(grade_key: "三段")

    battles = []
    battles << Swars::Battle.create_with_members!([user1, user2], {strike_plan: "嬉野流"})
    membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [1, 2]
    scope = Swars::Membership.where(id: membership_ids)
    QuickScript::Swars::TacticBattleMiningScript.new(scope: scope, item_keys: ["嬉野流"]).cache_write
    QuickScript::Swars::GradeBattleMiningScript.new({}, {scope: scope, grade_keys: ["二段"]}).cache_write

    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["初段"]).none? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["二段"]).exists? }
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
    assert { Swars::QueryResolver.resolve(current_swars_user: user1, query_info: QueryInfo.parse("嬉野流")).exists? }
  end
end
