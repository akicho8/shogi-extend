require "rails_helper"

RSpec.describe Swars::User::Stat::MateSpeedStat, type: :model, swars_spec: true do
  describe "詰ます速度" do
    def case1(final_key)
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate(time_list: [10, 20]), final_key: final_key) do |e|
        e.memberships.build(user: @black, judge_key: :win)
      end
      @black.stat.mate_speed_stat.average
    end

    it "works" do
      @black = Swars::User.create!
      assert { case1(:DISCONNECT) == nil } # CHECKMATE専用
      assert { case1(:CHECKMATE) == 15.0 }
      assert { case1(:CHECKMATE) == 15.0 } # 平均なので変化してない
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::MateSpeedStat
# >>   詰ます速度(1手平均) mate_speed_stat.average
# >>     works
# >>
# >> Swars::Top 1 slowest examples (1.31 seconds, 38.7% of total time):
# >>   Swars::User::Stat::MateSpeedStat 詰ます速度(1手平均) mate_speed_stat.average works
# >>     1.31 seconds -:17
# >>
# >> Swars::Finished in 3.39 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >>
