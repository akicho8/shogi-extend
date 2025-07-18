require "rails_helper"

RSpec.describe QuickScript::Swars::HourlyActiveUserScript, type: :model do
  it "works" do
    def entry(battled_at, user1, user2, grade_key1, grade_key2)
      @battles << Swars::Battle.create!(strike_plan: "糸谷流右玉", battled_at: battled_at) do |e|
        e.memberships.build(user: user1, grade_key: grade_key1)
        e.memberships.build(user: user2, grade_key: grade_key2)
      end
    end

    def aggregate
      @battles = []
      yield
      scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
      object = QuickScript::Swars::HourlyActiveUserScript.new({}, batch_size: 1, scope: scope)
      object.cache_write
      object.call.sort_by { |e| e[:"時"] }
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
    assert { rows[0] == { :"時" => 0, :"人数" => 2, :"強さ" => 33.0, :"曜日" => "水", :"対局数" => 1, } }
    assert { rows[1] == { :"時" => 1, :"人数" => 2, :"強さ" => 35.0, :"曜日" => "水", :"対局数" => 1, } }

    # 同じ時間帯に2度対局しても1度の対局と見なすが、日付が異なった場合は別の対局とする
    rows = aggregate do
      entry("2025-01-01 00:00", user1, user2, "二段", "四段")
      entry("2025-01-02 00:59", user1, user2, "二段", "四段")
    end
    assert { rows.size == 2 }
  end
end
