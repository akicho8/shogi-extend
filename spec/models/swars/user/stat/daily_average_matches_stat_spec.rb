require "rails_helper"

module Swars
  RSpec.describe User::Stat::DailyAverageMatchesStat, type: :model, swars_spec: true do
    describe "1日の対局数 平均 最大" do
      def case1(battled_at)
        Battle.create!(battled_at: battled_at) do |e|
          e.memberships.build(user: @black)
        end
        @black.stat.daily_average_matches_stat.average
      end

      it "works" do
        @black = User.create!
        assert { case1("2000-01-01") == 1.0 }
        assert { case1("2000-01-01") == 2.0 }
        assert { case1("2000-01-02") == 1.5 }
        assert { @black.stat.daily_average_matches_stat.max == 2 }
      end

      describe "バッジ" do
        it "廃指しマン" do
          @black = User.create!
          30.times { Battle.create! { |e| e.memberships.build(user: @black) } }
          assert { @black.stat.badge_stat.active?("廃指しマン") }
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::DailyAverageMatchesStat
# >>   1日の平均対局数
# >>     works
# >>
# >> Top 1 slowest examples (1.44 seconds, 41.1% of total time):
# >>   User::Stat::DailyAverageMatchesStat 1日の平均対局数 works
# >>     1.44 seconds -:17
# >>
# >> Finished in 3.5 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >>
