require "rails_helper"

module Swars
  RSpec.describe UserStat::WinLoseStreakStat, type: :model, swars_spec: true do
    describe "連勝・連敗" do
      def case1(list)
        @user = User.create!
        list.each.with_index do |win_or_lose, i|
          Battle.create!(battled_at: Time.current + i) do |e|
            e.memberships.build(user: @user, judge_key: win_or_lose)
          end
        end
        @user.user_stat.win_lose_streak_stat.to_h
      end

      it "works" do
        assert { case1([])                        == {} }
        assert { case1([:win])                    == { win: 1 } }
        assert { case1([:win, :lose, :win, :win]) == { win: 2, lose: 1 } }
      end

      it "10連勝" do
        case1([:win] * 10)
        assert { @user.user_stat.medal_stat.win_lose_streak_stat.ten_win? }
        assert { @user.user_stat.medal_stat.active?(:"10連勝") }
      end

      it "波が激しいマン" do
        case1([:win] * 5 + [:lose] * 5)
        assert { @user.user_stat.medal_stat.win_lose_streak_stat.waves_strong? }
        assert { @user.user_stat.medal_stat.active?(:"波が激しいマン") }
      end
    end
  end
end
