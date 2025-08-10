require "rails_helper"

RSpec.describe Swars::QueryResolver, type: :model, swars_spec: true do
  it "works" do
    user1 = Swars::User.create!(grade_key: "二段").tap(&:ban!)
    user2 = Swars::User.create!(grade_key: "三段")

    battles = []
    battles << Swars::Battle.create_with_members!([user1, user2], { strike_plan: "四間飛車" })
    membership_ids = battles.flat_map(&:memberships).collect(&:id) # => [1, 2]
    scope = Swars::Membership.where(id: membership_ids)

    # tp battles.first.info
    # |----------+--------------------------------------------------------------------------------------------------------------------------------------|
    # |       ID | 1                                                                                                                                    |
    # |   ルール | 10分                                                                                                                                 |
    # |     結末 | 投了                                                                                                                                 |
    # | 開始局面 | 通常                                                                                                                                 |
    # |   モード | 野良                                                                                                                                 |
    # |   手合割 | 平手                                                                                                                                 |
    # |     開戦 | 9                                                                                                                                    |
    # |     中盤 | 72                                                                                                                                   |
    # |     手数 | 92                                                                                                                                   |
    # |       ▲ | user1 二段 勝ち (矢倉 突き捨て 飛車先交換 突き違いの歩 浮き飛車 たたきの歩 連打の歩 歩裏の歩 桂頭攻め 居飛車 相居飛車 持久戦 長手数) |
    # |       △ | user2 三段 負け (四間飛車 引き角 突き捨て たたきの歩 歩裏の歩 角頭攻め 角切り 裾銀 居飛車 相居飛車 持久戦 長手数)                      |
    # | 対局日時 | 2000-01-01 00:00:00                                                                                                                  |
    # | 対局秒数 | 226                                                                                                                                  |
    # | 終了日時 | 2000-01-01 00:03:46                                                                                                                  |
    # |     勝者 | user1                                                                                                                                |
    # | 最終参照 | 2000-01-01 00:00:00                                                                                                                  |
    # |----------+--------------------------------------------------------------------------------------------------------------------------------------|

    QuickScript::Swars::TacticBattleMiningScript.new({}, scope: scope, item_keys: ["四間飛車"]).cache_write
    QuickScript::Swars::GradeBattleMiningScript.new({}, { scope: scope, grade_keys: ["二段"] }).cache_write
    QuickScript::Swars::PresetBattleMiningScript.new({}, { scope: scope, preset_keys: ["平手"] }).cache_write
    QuickScript::Swars::StyleBattleMiningScript.new({}, { scope: scope, style_keys: ["王道"] }).cache_write

    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["初段"]).none? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["二段"]).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("四間飛車")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["平手"]).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo["王道"]).exists? }

    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("id:#{battles.sole.id}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("ids:#{battles.sole.id}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("key:#{battles.sole.key}")).exists? }
    assert { Swars::QueryResolver.resolve(query_info: QueryInfo.parse("keys:#{battles.sole.key}")).exists? }
    assert { Swars::QueryResolver.resolve(params: { id: battles.sole.id }).exists? }
    assert { Swars::QueryResolver.resolve(params: { ids: battles.sole.id }).exists? }
    assert { Swars::QueryResolver.resolve(params: { key: battles.sole.key }).exists? }
    assert { Swars::QueryResolver.resolve(params: { keys: battles.sole.key }).exists? }
    assert { Swars::QueryResolver.resolve(params: { all: 1 }).exists? }
    assert { Swars::QueryResolver.resolve(params: { ban: 1 }).exists? }
    assert { Swars::QueryResolver.resolve(current_swars_user: user1, query_info: QueryInfo.parse("四間飛車")).exists? }
  end
end
