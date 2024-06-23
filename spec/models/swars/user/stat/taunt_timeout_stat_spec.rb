require "rails_helper"

module Swars
  RSpec.describe User::Stat::TauntTimeoutStat, type: :model, swars_spec: true do
    describe "必勝形から焦らして悦に入った回数" do
      def case1(last_sec)
        @black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [0, 0, last_sec]), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black)
        end
        stat = @black.stat
        [
          stat.taunt_timeout_stat.max,
          stat.taunt_timeout_stat.to_chart,
        ]
      end

      it "works" do
        assert { case1(44) == [nil, nil] }
        assert { case1(45) == [45, [{name: "45秒", value: 1}]] }
        assert { case1(60) == [60, [{name: "1分",  value: 1}]] }
        assert { case1(61) == [61, [{name: "1分",  value: 1}]] }
      end

      describe "バッジ" do
        def case1
          @black = User.create!
          Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :TIMEOUT) do |e|
            e.memberships.build(user: @black)
          end
        end

        it "必勝形焦らしマン" do
          case1
          assert { @black.stat.badge_stat.active?(:"必勝形焦らしマン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::TauntTimeoutStat
# >>   必勝形から焦らして悦に入った回数
# >>     works
# >>
# >> Top 1 slowest examples (1.49 seconds, 41.8% of total time):
# >>   User::Stat::TauntTimeoutStat 必勝形から焦らして悦に入った回数 works
# >>     1.49 seconds -:18
# >>
# >> Finished in 3.56 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >>
