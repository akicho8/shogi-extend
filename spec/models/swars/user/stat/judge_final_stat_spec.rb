require "rails_helper"

module Swars
  RSpec.describe User::Stat::JudgeFinalStat, type: :model, swars_spec: true do
    describe "勝ち負け時の結末の内訳" do
      def case1(judge_key, final_key)
        Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "to_chart" do
        @black = User.create!
        case1(:win, :CHECKMATE)
        case1(:win, :TORYO)
        case1(:lose, :CHECKMATE)
        assert do
          @black.stat.judge_final_stat.to_chart(:win) == [
            {:key => :TORYO,     :name => "投了",     :value => 1},
            {:key => :TIMEOUT,   :name => "時間切れ", :value => 0},
            {:key => :CHECKMATE, :name => "詰み",     :value => 1},
          ]
        end
      end

      it "count_by" do
        @black = User.create!
        case1(:win, :CHECKMATE)
        assert { @black.stat.judge_final_stat.count_by(:win, :CHECKMATE) == 1 }
      end

      it "ratio_by" do
        @black = User.create!
        case1(:win, :CHECKMATE)
        assert { @black.stat.judge_final_stat.ratio_by(:win, :CHECKMATE) == 1.0 }
      end

      it "counts_hash" do
        @black = User.create!
        case1(:win, :CHECKMATE)
        assert { @black.stat.judge_final_stat.counts_hash == { [:win, :CHECKMATE] => 1} }
      end

      describe "対戦成立条件は最低2手指すこと" do
        def case1(turn_max)
          black = User.create!
          battle = Battle.create!(csa_seq: KifuGenerator.generate_n(turn_max), final_key: :DISCONNECT) do |e|
            e.memberships.build(user: black, judge_key: :lose)
          end
          black.stat.judge_final_stat.count_by(:lose, :DISCONNECT)
        end

        it "works" do
          assert { case1(1) == nil }
          assert { case1(2) == 1   }
        end
      end

      describe "バッジ" do
        it "切断マン" do
          @black = User.create!
          case1(:lose, :DISCONNECT)
          assert { @black.stat.badge_stat.active?("切断マン") }
        end

        it "切れ負けマン" do
          @black = User.create!
          case1(:lose, :TIMEOUT)
          assert { @black.stat.badge_stat.active?("切れ負けマン") }
        end

        it "投了マン" do
          @black = User.create!
          5.times { case1(:lose, :TORYO) }
          assert { @black.stat.badge_stat.active?("投了マン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::User::Stat::JudgeFinalStat
# >>   勝ち負け時の結末の内訳
# >>     to_chart
# >>     count_by
# >>     ratio_by
# >>     counts_hash
# >>     最低2手指さないと判定しない
# >> [7754, 0]
# >> nil
# >> [7755, 1]
# >> nil
# >> [7756, 2]
# >> 1
# >>       works
# >>     バッジ
# >>       切断マン
# >>       切れ負けマン
# >>       投了マン
# >> 
# >> Top 5 slowest examples (1.55 seconds, 37.5% of total time):
# >>   Swars::User::Stat::JudgeFinalStat 勝ち負け時の結末の内訳 to_chart
# >>     0.74007 seconds -:12
# >>   Swars::User::Stat::JudgeFinalStat 勝ち負け時の結末の内訳 最低2手指さないと判定しない works
# >>     0.30066 seconds -:55
# >>   Swars::User::Stat::JudgeFinalStat 勝ち負け時の結末の内訳 バッジ 切れ負けマン
# >>     0.17203 seconds -:69
# >>   Swars::User::Stat::JudgeFinalStat 勝ち負け時の結末の内訳 count_by
# >>     0.17194 seconds -:26
# >>   Swars::User::Stat::JudgeFinalStat 勝ち負け時の結末の内訳 バッジ 投了マン
# >>     0.16107 seconds -:75
# >> 
# >> Finished in 4.13 seconds (files took 1.63 seconds to load)
# >> 8 examples, 0 failures
# >> 
