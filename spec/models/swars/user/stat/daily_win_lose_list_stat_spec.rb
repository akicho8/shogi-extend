require "rails_helper"

RSpec.describe Swars::User::Stat::DailyWinLoseListStat, type: :model, swars_spec: true do
  describe "日別勝敗リスト" do
    def case1(battled_at, judge_key)
      @black = Swars::User.create!
      Swars::Battle.create!(battled_at: battled_at) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
      end
      if el = @black.stat.daily_win_lose_list_stat.to_chart.first
        el[:battled_on].strftime("%F")
      end
    end

    it "works" do
      assert { case1("2000-01-02 02:59", :win)  == "2000-01-01" }
      assert { case1("2000-01-02 03:00", :lose) == "2000-01-02" }
      assert { case1("2000-01-01 00:00", :draw) == nil          }
    end
  end
end
