require "rails_helper"

RSpec.describe QuickScript::Swars::TacticCrossScript, type: :model do
  it "works" do
    begin
      user1 = Swars::User.create!(grade_key: "九段")
      user2 = Swars::User.create!(grade_key: "八段")
      ::Swars::Battle.create_with_members!([user1, user2], {strike_plan: "嬉野流"})

      QuickScript::Swars::TacticCrossScript.new({}, {batch_limit: 1}).cache_write
    end

    e = QuickScript::Swars::TacticCrossScript.new
    assert { e.current_items_hash.count == 2 }
    assert { e.current_items_hash[:"九段"] }
    assert { e.current_items_hash[:"八段"] }

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
