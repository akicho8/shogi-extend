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
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >>
# >> Swars::User::Stat::TurnStat
# >>   平均手数・最長手数
# >>     average
# >>     max
# >>
# >> Top 2 slowest examples (1.08 seconds, 32.6% of total time):
# >>   Swars::User::Stat::TurnStat 平均手数・最長手数 average
# >>     0.83426 seconds -:12
# >>   Swars::User::Stat::TurnStat 平均手数・最長手数 max
# >>     0.24852 seconds -:18
# >>
# >> Finished in 3.32 seconds (files took 1.36 seconds to load)
# >> 2 examples, 0 failures
# >>
