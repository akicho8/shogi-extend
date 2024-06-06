require "rails_helper"

module Swars
  RSpec.describe UserStat::DailyWinLossListStat, type: :model, swars_spec: true do
    describe "日別勝敗リスト" do
      def case1(battled_at, judge_key)
        Battle.create!(battled_at: battled_at) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "works" do
        @black = User.create!
        case1("2000-01-01", :win)
        case1("2000-01-02", :lose)
        assert do
          @black.user_stat.daily_win_loss_list_stat.to_chart == [
            {:battled_on => "2000-01-02".to_date, :day_type => :danger, :judge_counts => {:win => 0, :lose => 1}},
            {:battled_on => "2000-01-01".to_date, :day_type => :info,   :judge_counts => {:win => 1, :lose => 0}},
          ]
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> UserStat::DailyWinLossListStat
# >>   日別勝敗リスト
# >>     works
# >>
# >> Top 1 slowest examples (0.52132 seconds, 20.1% of total time):
# >>   UserStat::DailyWinLossListStat 日別勝敗リスト works
# >>     0.52132 seconds -:17
# >>
# >> Finished in 2.59 seconds (files took 1.55 seconds to load)
# >> 1 example, 0 failures
# >>
