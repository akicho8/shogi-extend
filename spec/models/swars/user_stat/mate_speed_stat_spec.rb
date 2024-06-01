require "rails_helper"

module Swars
  RSpec.describe UserStat::MateSpeedStat, type: :model, swars_spec: true do
    describe "詰ます速度" do
      before do
        @black = User.create!
      end

      def case1(final_key)
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [10, 20]), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :win)
        end
        @black.user_stat.mate_speed_stat.average
      end

      it "works" do
        assert { case1(:DISCONNECT) == nil } # CHECKMATE専用
        assert { case1(:CHECKMATE) == 15.0 }
        assert { case1(:CHECKMATE) == 15.0 } # 平均なので変化してない
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MateSpeedStat
# >>   詰ます速度(1手平均) mate_speed_stat.average
# >>     works
# >> 
# >> Top 1 slowest examples (1.31 seconds, 38.7% of total time):
# >>   Swars::UserStat::MateSpeedStat 詰ます速度(1手平均) mate_speed_stat.average works
# >>     1.31 seconds -:17
# >> 
# >> Finished in 3.39 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
