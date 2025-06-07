require "rails_helper"

RSpec.describe QuickScript::Swars::TacticStatScript, type: :model do
  it "整合性" do
    def case1(kifu_body_list)
      user1 = Swars::User.create!
      user2 = Swars::User.create!
      battles = kifu_body_list.collect { |e| Swars::Battle.create_with_members!([user1, user2], {kifu_body_for_test: e}) }
      scope = Swars::Membership.where(id: battles.flat_map(&:membership_ids))
      object = QuickScript::Swars::TacticStatScript.new({period_key: :infinite}, {batch_size: 1, scope: scope})
      object.cache_write
      object.aggregate[:day7]
    end

    assert { case1(["▲68銀"])           == [{勝ち: 1, 勝率: 1.0, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 0, 人気度: 1.0, 登場率: 0.5, スタイル: "王道", 使用人数: 1, 登場回数: 1}] }
    assert { case1(["▲68銀△42銀"])     == [{勝ち: 1, 勝率: 0.5, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 1, 人気度: 1.0, 登場率: 1.0, スタイル: "王道", 使用人数: 2, 登場回数: 2}] }
    assert { case1(["▲68銀△42銀"] * 2) == [{勝ち: 2, 勝率: 0.5, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 2, 人気度: 1.0, 登場率: 1.0, スタイル: "王道", 使用人数: 2, 登場回数: 4}] }
  end

  it "フォーム関連" do
    Swars::Battle.create!(strike_plan: "原始棒銀")
    QuickScript::Swars::TacticBattleMiningScript.new.cache_write
    QuickScript::Swars::TacticStatScript.new.cache_write

    def case1(params)
      instance = QuickScript::Swars::TacticStatScript.new({ freq_ratio_gteq: 0, **params })
      instance.as_json
      instance.human_rows.present?
    end

    assert { case1(scope_key: :attack)             }
    assert { case1(scope_key: :attack_and_defense) }
    assert { case1(scope_key: :note)               }
    assert { case1(scope_key: :all)                }

    assert { case1(scope_key: :right_king) }
    assert { case1(scope_key: :technique) }

    assert { case1(order_key: :win_rate) }
    assert { case1(order_key: :popular)  }

    assert { case1(period_key: :day7)     }
    assert { case1(period_key: :infinite) }
  end
end
