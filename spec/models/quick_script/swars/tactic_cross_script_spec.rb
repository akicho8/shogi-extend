require "rails_helper"

RSpec.describe QuickScript::Swars::TacticCrossScript, type: :model do
  it "整合性" do
    def case1(grade_keys, kifu_body_list)
      users = grade_keys.collect { |e| Swars::User.create!(grade_key: e) }
      battles = kifu_body_list.collect { |e| Swars::Battle.create_with_members!(users, { kifu_body_for_test: e }) }
      scope = Swars::Membership.where(id: battles.flat_map(&:membership_ids))
      object = QuickScript::Swars::TacticCrossScript.new({}, { batch_size: 1, scope: scope, verbose: false })
      object.cache_write
      object.aggregate
    end

    assert { case1(["1級", "1級"], ["▲68銀"])           == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 0.5, 人気度: 1.0, 勝ち: 1, 負け: 0, 引分: 0, 出現回数: 1, 使用人数: 1 }] }
    assert { case1(["1級", "1級"], ["▲68銀△42銀"])     == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.5, 出現率: 1.0, 人気度: 1.0, 勝ち: 1, 負け: 1, 引分: 0, 出現回数: 2, 使用人数: 2 }] }
    assert { case1(["1級", "1級"], ["▲68銀△42銀"] * 2) == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.5, 出現率: 1.0, 人気度: 1.0, 勝ち: 2, 負け: 2, 引分: 0, 出現回数: 4, 使用人数: 2 }] }
    assert { case1(["1級", "1級"], ["▲68銀△62玉"])     == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 0.5, 人気度: 0.5, 勝ち: 1, 負け: 0, 引分: 0, 出現回数: 1, 使用人数: 1 }, { 棋力: "1級", 名前: "新米長玉", 種類: "戦法", スタイル: "準変態", 勝率: 0.0, 出現率: 0.5, 人気度: 0.5, 勝ち: 0, 負け: 1, 引分: 0, 出現回数: 1, 使用人数: 1 }, { 棋力: "1級", 名前: "右玉", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 0.5, 人気度: 0.5, 勝ち: 0, 負け: 1, 引分: 0, 出現回数: 1, 使用人数: 1 }] }

    assert { case1(["1級", "2級"], ["▲68銀"])           == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 1, 負け: 0, 引分: 0, 出現回数: 1, 使用人数: 1 }] }
    assert { case1(["1級", "2級"], ["▲68銀△42銀"])     == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 1, 負け: 0, 引分: 0, 出現回数: 1, 使用人数: 1 }, { 棋力: "2級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 0, 負け: 1, 引分: 0, 出現回数: 1, 使用人数: 1 }] }
    assert { case1(["1級", "2級"], ["▲68銀△42銀"] * 2) == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 2, 負け: 0, 引分: 0, 出現回数: 2, 使用人数: 1 }, { 棋力: "2級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 0, 負け: 2, 引分: 0, 出現回数: 2, 使用人数: 1 }] }
    assert { case1(["1級", "2級"], ["▲68銀△62玉"])     == [{ 棋力: "1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 1, 負け: 0, 引分: 0, 出現回数: 1, 使用人数: 1 }, { 棋力: "2級", 名前: "新米長玉", 種類: "戦法", スタイル: "準変態", 勝率: 0.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 0, 負け: 1, 引分: 0, 出現回数: 1, 使用人数: 1 }, { 棋力: "2級", 名前: "右玉", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 1.0, 人気度: 1.0, 勝ち: 0, 負け: 1, 引分: 0, 出現回数: 1, 使用人数: 1 }] }
  end

  it "UI" do
    user1 = Swars::User.create!
    user2 = Swars::User.create!
    ::Swars::Battle.create_with_members!([user1, user2], { strike_plan: "嬉野流" })
    QuickScript::Swars::TacticCrossScript.new({}, { batch_limit: 1 }).cache_write

    def case1(params = {})
      params = { freq_ratio_gteq: 0 }.merge(params)
      QuickScript::Swars::TacticCrossScript.new(params).as_json
    end

    assert { case1(show_key: :normal) }
    assert { case1(show_key: :highlight) }
    assert { case1(show_key: :dot) }
    assert { case1(show_key: :with_score) }
    assert { case1(show_key: :debug) }

    assert { case1(scope_key: :attack) }
    assert { case1(scope_key: :defense) }
    assert { case1(scope_key: :attack_and_defense) }
    assert { case1(scope_key: :right_king) }
    assert { case1(scope_key: :technique) }
    assert { case1(scope_key: :note) }
    assert { case1(scope_key: :all) }

    assert { case1(order_key: :popular) }
    assert { case1(order_key: :win_rate) }

    assert { case1(arrow_key: :left_to_right) }
    assert { case1(arrow_key: :right_to_left) }

    assert { case1(highlight_plus: "嬉野流")  }
    assert { case1(highlight_minus: "嬉野流")  }
  end
end
