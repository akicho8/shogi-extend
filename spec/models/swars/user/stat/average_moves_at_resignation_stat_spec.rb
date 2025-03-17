require "rails_helper"

RSpec.describe Swars::User::Stat::AverageMovesAtResignationStat, type: :model, swars_spec: true do
  describe "投了時の平均手数" do
    def case1(n, final_key, judge_key)
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: final_key) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
      end
      @black.stat.average_moves_at_resignation_stat.average
    end

    it "works" do
      @black = Swars::User.create!
      assert { case1(2, :TORYO, :lose)      == 2 }
      assert { case1(8, :TORYO, :lose)      == 5 }
      assert { case1(9, :DISCONNECT, :lose) == 5 } # TORYO で lose 専用なので結果は変わらない
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::AverageMovesAtResignationStat
# >>   勝敗別平均手数
# >>     works
# >>
# >> Swars::Top 1 slowest examples (1.57 seconds, 43.0% of total time):
# >>   Swars::User::Stat::AverageMovesAtResignationStat 勝敗別平均手数 works
# >>     1.57 seconds -:17
# >>
# >> Swars::Finished in 3.64 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
