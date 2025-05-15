require "rails_helper"

RSpec.describe QuickScript::Swars::HourlyActiveUserScript, type: :model do
  it "works" do
    def reset
      Swars::Battle.destroy_all
      Swars::User.destroy_all
    end

    def entry(battled_at, user1, user2, grade_key1, grade_key2)
      Swars::Battle.create!(strike_plan: "糸谷流右玉", battled_at: battled_at) do |e|
        e.memberships.build(user: user1, grade_key: grade_key1)
        e.memberships.build(user: user2, grade_key: grade_key2)
      end
    end

    def aggregate
      reset
      yield
      object = QuickScript::Swars::HourlyActiveUserScript.new({}, batch_limit: 1)
      object.cache_write
      object.call.sort_by { |e| e[:hour] }
    end

    user1 = Swars::User.create!
    user2 = Swars::User.create!

    # 同じ時間帯に2度対局しても1度の対局と見なす
    rows = aggregate do
      entry("2025-01-01 00:00", user1, user2, "二段", "四段")
      entry("2025-01-01 00:59", user1, user2, "二段", "四段")
    end
    assert { rows.size == 1 }

    # 時間を跨いでいる別々に集計する
    rows = aggregate do
      entry("2025-01-01 00:00", user1, user2, "二段", "四段")
      entry("2025-01-01 01:00", user1, user2, "五段", "五段")
    end
    assert { rows.size == 2 }
    assert { rows[0][:relative_strength] == 0.0 }
    assert { rows[1][:relative_strength] == 1.0 }

    # 同じ時間帯に2度対局しても1度の対局と見なすが、日付が異なった場合は別の対局とする
    rows = aggregate do
      entry("2025-01-01 00:00", user1, user2, "二段", "四段")
      entry("2025-01-02 00:59", user1, user2, "二段", "四段")
    end
    assert { rows.size == 2 }
  end
end
