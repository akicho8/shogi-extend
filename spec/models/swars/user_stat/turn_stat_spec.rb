require "rails_helper"

module Swars
  RSpec.describe UserStat::TurnStat, type: :model, swars_spec: true do
    describe "平均手数・最長手数" do
      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.user_stat.turn_stat
      end

      it "average" do
        @black = User.create!
        assert { case1(2).average == 2 }
        assert { case1(8).average == 5 }
      end

      it "max" do
        @black = User.create!
        assert { case1(2).max == 2 }
        assert { case1(8).max == 8 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::TurnStat
# >>   平均手数・最長手数
# >>     average
# >>     max
# >> 
# >> Top 2 slowest examples (1.53 seconds, 42.6% of total time):
# >>   UserStat::TurnStat 平均手数・最長手数 average
# >>     1.14 seconds -:17
# >>   UserStat::TurnStat 平均手数・最長手数 max
# >>     0.39505 seconds -:22
# >> 
# >> Finished in 3.6 seconds (files took 1.55 seconds to load)
# >> 2 examples, 0 failures
# >> 
