require "rails_helper"

module Swars
  RSpec.describe User::Stat::LeaveAloneStat, type: :model, swars_spec: true do
    describe "投了せずに放置した回数 / 投了せずに放置した時間" do
      def case1
        Battle.create!(final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        stat = @black.stat
        [
          stat.leave_alone_stat.max,
          stat.leave_alone_stat.to_chart,
        ]
      end

      it "works" do
        @black = User.create!
        assert { case1 == [600, [{name: "10分", value: 1}]] }
        assert { case1 == [600, [{name: "10分", value: 2}]] }
      end

      describe "バッジ" do
        def case1
          @black = User.create!
          Battle.create!(final_key: :TIMEOUT) do |e|
            e.memberships.build(user: @black, judge_key: :lose)
          end
        end

        it "絶対投了しないマン" do
          case1
          assert { @black.stat.badge_stat.active?(:"絶対投了しないマン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::LeaveAloneStat
# >>   投了せずに放置した回数 / 投了せずに放置した時間
# >>     works
# >>
# >> Top 1 slowest examples (1.35 seconds, 39.5% of total time):
# >>   User::Stat::LeaveAloneStat 投了せずに放置した回数 / 投了せずに放置した時間 works
# >>     1.35 seconds -:21
# >>
# >> Finished in 3.42 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
