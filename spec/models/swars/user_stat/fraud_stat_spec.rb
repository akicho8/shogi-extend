require "rails_helper"

module Swars
  RSpec.describe UserStat::FraudStat, type: :model, swars_spec: true do
    describe "将棋ウォーズの運営を支える力" do
      def case1(size)
        csa_seq = KifuGenerator.fraud_pattern(size: size)
        battle = Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.fraud_stat.to_chart&.collect { |e| e[:value] }
      end

      it "works" do
        @black = User.create!
        assert { case1(28) == nil    }
        assert { case1(29) == [1, 1] }
        assert { case1(29) == [2, 1] }
      end

      describe "バッジ" do
        def case1(pattern)
          @black = User.create!
          Battle.create!(csa_seq: KifuGenerator.send(pattern), final_key: :CHECKMATE) do |e|
            e.memberships.build(user: @black, judge_key: :win)
          end
          @black.user_stat.badge_stat
        end

        it "運営支えマン" do
          assert { case1(:fraud_pattern).active?(:"運営支えマン") }
          assert { !case1(:no_fraud_pattern).active?(:"運営支えマン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> UserStat::FraudStat
# >>   将棋ウォーズの運営を支える力
# >>     works
# >>
# >> Top 1 slowest examples (1.45 seconds, 41.1% of total time):
# >>   UserStat::FraudStat 将棋ウォーズの運営を支える力 works
# >>     1.45 seconds -:14
# >>
# >> Finished in 3.52 seconds (files took 1.57 seconds to load)
# >> 1 example, 0 failures
# >>
