require "rails_helper"

RSpec.describe Swars::User::Stat::VitalityStat, type: :model, swars_spec: true do
  describe "勢い" do
    def case1(n, judge_key)
      black = Swars::User.create!
      n.times do
        Swars::Battle.create! do |e|
          e.memberships.build(user: black, judge_key: judge_key)
        end
      end
      black.stat.vitality_stat
    end

    it "vital_and_strong?" do
      assert { case1(3 * 5 + 0, :win).vital_and_strong? == false } # 野良で1日3局指して全勝
      assert { case1(3 * 5 + 1, :win).vital_and_strong? == true  } # 野良で1日3局指した上に友対を1局指して全勝
    end

    it "vital_but_weak?" do
      assert { case1(3 * 5 + 0, :lose).vital_but_weak? == false } # 野良で1日3局指して全敗
      assert { case1(3 * 5 + 1, :lose).vital_but_weak? == true  } # 野良で1日3局指した上に友対を1局指して全敗
    end
  end
end
