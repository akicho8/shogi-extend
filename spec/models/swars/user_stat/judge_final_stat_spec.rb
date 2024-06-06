require "rails_helper"

module Swars
  RSpec.describe UserStat::JudgeFinalStat, type: :model, swars_spec: true do
    describe "勝ち負け時の結末の内訳" do
      def case1(final_key, judge_key)
        Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "to_chart" do
        @black = User.create!
        case1(:CHECKMATE, :win)
        case1(:TORYO,     :win)
        case1(:CHECKMATE, :lose)
        assert do
          @black.user_stat.judge_final_stat.to_chart(:win) == [
            {:key => :TORYO,     :name => "投了",     :value => 1},
            {:key => :TIMEOUT,   :name => "時間切れ", :value => 0},
            {:key => :CHECKMATE, :name => "詰み",     :value => 1},
          ]
        end
      end

      it "count_by" do
        @black = User.create!
        case1(:CHECKMATE, :win)
        assert { @black.user_stat.judge_final_stat.count_by(:win, :CHECKMATE) == 1 }
      end

      it "ratio_by" do
        @black = User.create!
        case1(:CHECKMATE, :win)
        assert { @black.user_stat.judge_final_stat.ratio_by(:win, :CHECKMATE) == 1.0 }
      end

      it "counts_hash" do
        @black = User.create!
        case1(:CHECKMATE, :win)
        assert { @black.user_stat.judge_final_stat.counts_hash == {["win", "CHECKMATE"] => 1} }
      end

      describe "バッジ" do
        it "切断マン" do
          @black = User.create!
          case1(:DISCONNECT, :lose)
          assert { @black.user_stat.badge_stat.active?("切断マン") }
        end

        it "切れ負けマン" do
          @black = User.create!
          case1(:TIMEOUT, :lose)
          assert { @black.user_stat.badge_stat.active?("切れ負けマン") }
        end

        it "投了マン" do
          @black = User.create!
          case1(:TORYO, :lose)
          assert { @black.user_stat.badge_stat.active?("投了マン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> UserStat::JudgeFinalStat
# >>   勝ち負け時の結末の内訳
# >>     to_chart
# >>     count_by
# >>     ratio_by
# >>     counts_hash
# >>
# >> Top 4 slowest examples (1.14 seconds, 35.3% of total time):
# >>   UserStat::JudgeFinalStat 勝ち負け時の結末の内訳 to_chart
# >>     0.72114 seconds -:12
# >>   UserStat::JudgeFinalStat 勝ち負け時の結末の内訳 count_by
# >>     0.14118 seconds -:26
# >>   UserStat::JudgeFinalStat 勝ち負け時の結末の内訳 ratio_by
# >>     0.14106 seconds -:32
# >>   UserStat::JudgeFinalStat 勝ち負け時の結末の内訳 counts_hash
# >>     0.13575 seconds -:38
# >>
# >> Finished in 3.23 seconds (files took 1.57 seconds to load)
# >> 4 examples, 0 failures
# >>
