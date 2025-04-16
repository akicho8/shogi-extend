require "rails_helper"

RSpec.describe QuickScript::Swars::TacticStatScript, type: :model do
  def case1(params)
    instance = QuickScript::Swars::TacticStatScript.new({ freq_ratio_gteq: 0, **params })
    instance.as_json
    !instance.table_rows.empty?
  end

  it "works" do
    QuickScript::Swars::TacticStatScript::PrimaryAggregator.mock_setup
    QuickScript::Swars::TacticStatScript.primary_aggregate_call

    assert { case1(scope_key: :attack)             }
    assert { case1(scope_key: :attack_and_defense) }
    assert { case1(scope_key: :note)               }
    assert { case1(scope_key: :all)                }

    assert { case1(scope_key: :right_king) == false }
    assert { case1(scope_key: :technique)  == false }

    assert { case1(order_key: :win_rate) }
    assert { case1(order_key: :popular)  }

    assert { case1(period_key: :day1)  }
    assert { case1(period_key: :year1) }
  end
end
