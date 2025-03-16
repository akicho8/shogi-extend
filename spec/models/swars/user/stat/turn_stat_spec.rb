require "rails_helper"

RSpec.describe Swars::User::Stat::TurnStat, type: :model, swars_spec: true do
  describe "平均手数・最長手数" do
    def case1(n)
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n)) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
      end
      @black.stat.turn_stat
    end

    it "average" do
      @black = Swars::User.create!
      assert { case1(2).average == 2 }
      assert { case1(8).average == 5 }
    end

    it "max" do
      @black = Swars::User.create!
      assert { case1(2).max == 2 }
      assert { case1(8).max == 8 }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::TurnStat
# >>   平均手数・最長手数
# >>     average
# >>     max
# >>
# >> Swars::Top 2 slowest examples (1.53 seconds, 42.6% of total time):
# >>   Swars::User::Stat::TurnStat 平均手数・最長手数 average
# >>     1.14 seconds -:17
# >>   Swars::User::Stat::TurnStat 平均手数・最長手数 max
# >>     0.39505 seconds -:22
# >>
# >> Swars::Finished in 3.6 seconds (files took 1.55 seconds to load)
# >> 2 examples, 0 failures
# >>
