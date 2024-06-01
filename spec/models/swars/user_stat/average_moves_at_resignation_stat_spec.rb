require "rails_helper"

module Swars
  RSpec.describe UserStat::AverageMovesAtResignationStat, type: :model, swars_spec: true do
    describe "投了時の平均手数" do
      before do
        @black = User.create!
      end

      def case1(n, final_key, judge_key)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        @black.user_stat.average_moves_at_resignation_stat.average
      end

      it "works" do
        assert { case1(2, :TORYO, :lose)      == 2 }
        assert { case1(8, :TORYO, :lose)      == 5 }
        assert { case1(9, :DISCONNECT, :lose) == 5 } # TORYO で lose 専用なので結果は変わらない
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::UserStat::AverageMovesAtResignationStat
# >>   勝敗別平均手数
# >>     works
# >>
# >> Top 1 slowest examples (1.57 seconds, 43.0% of total time):
# >>   Swars::UserStat::AverageMovesAtResignationStat 勝敗別平均手数 works
# >>     1.57 seconds -:17
# >>
# >> Finished in 3.64 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
