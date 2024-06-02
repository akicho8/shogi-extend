require "rails_helper"

module Swars
  RSpec.describe UserStat::OverthinkingLossStat, type: :model, swars_spec: true do
    describe "長考マン" do
      def case1(min)
        seconds = min.minutes
        @black = User.create!
        csa_seq = [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]]
        Swars::Battle.create!(csa_seq: csa_seq, final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.user_stat.medal_stat.to_set
      end

      it "works" do
        # 2.5...3.0
        assert { case1(2.4).exclude?(:"長考マン") }
        assert { case1(2.5).include?(:"長考マン") }
        assert { case1(3.0).exclude?(:"長考マン") }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::OverthinkingLossStat
# >>   長考マン
# >>     works
# >> 
# >> Top 1 slowest examples (1.55 seconds, 42.8% of total time):
# >>   Swars::UserStat::OverthinkingLossStat 長考マン works
# >>     1.55 seconds -:16
# >> 
# >> Finished in 3.61 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
