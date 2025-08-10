require "rails_helper"

RSpec.describe Swars::User::Stat::WinLoseStreakStat, type: :model, swars_spec: true do
  describe "連勝・連敗" do
    def case1(list)
      @user = Swars::User.create!
      list.each.with_index do |win_or_lose, i|
        Swars::Battle.create!(battled_at: Time.current + i) do |e|
          e.memberships.build(user: @user, judge_key: win_or_lose)
        end
      end
      @user.stat.win_lose_streak_stat.to_h
    end

    it "works" do
      assert { case1([])                        == {} }
      assert { case1([:win])                    == { win: 1 } }
      assert { case1([:win, :lose, :win, :win]) == { win: 2, lose: 1 } }
    end

    it "5連勝" do
      case1([:win] * 5)
      assert { @user.stat.badge_stat.win_lose_streak_stat.five_win? }
      assert { @user.stat.badge_stat.active?(:"5連勝") }
    end

    it "10連勝" do
      case1([:win] * 10)
      assert { @user.stat.badge_stat.win_lose_streak_stat.ten_win? }
      assert { @user.stat.badge_stat.active?(:"10連勝") }
    end

    it "波が激しいマン" do
      case1([:win] * 8 + [:lose] * 8)
      assert { @user.stat.badge_stat.win_lose_streak_stat.waves_strong? }
      assert { @user.stat.badge_stat.active?(:"波が激しいマン") }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::WinLoseStreakStat
# >>   連勝・連敗
# >>     works
# >>     10連勝
# >>     波が激しいマン
# >>
# >> Swars::Top 3 slowest examples (3.42 seconds, 61.7% of total time):
# >>   Swars::User::Stat::WinLoseStreakStat 連勝・連敗 works
# >>     1.56 seconds -:16
# >>   Swars::User::Stat::WinLoseStreakStat 連勝・連敗 波が激しいマン
# >>     1.11 seconds -:28
# >>   Swars::User::Stat::WinLoseStreakStat 連勝・連敗 10連勝
# >>     0.73999 seconds -:22
# >>
# >> Swars::Finished in 5.54 seconds (files took 1.99 seconds to load)
# >> 3 examples, 0 failures
# >>
