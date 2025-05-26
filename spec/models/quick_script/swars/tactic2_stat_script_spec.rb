require "rails_helper"

RSpec.describe QuickScript::Swars::Tactic2StatScript, type: :model do
  def case1(params)
    instance = QuickScript::Swars::Tactic2StatScript.new({ freq_ratio_gteq: 0, **params })
    instance.as_json
    instance.rows.present?
  end

  it "works" do
    Swars::Battle.create!(strike_plan: "原始棒銀")
    QuickScript::Swars::TacticBattleAggregator.new.cache_write
    QuickScript::Swars::TacticJudgeAggregator.new.cache_write

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
