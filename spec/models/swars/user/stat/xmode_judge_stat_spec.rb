require "rails_helper"

RSpec.describe Swars::User::Stat::XmodeJudgeStat, type: :model, swars_spec: true do
  describe "対局モードと勝敗" do
    def case1(xmode_key, judge_key)
      @black = Swars::User.create!
      Swars::Battle.create!(xmode_key: xmode_key) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
      end
    end

    before do
      case1(:"指導", :win)
    end

    it "to_chart" do
      assert { @black.stat.xmode_judge_stat.to_chart(:"指導") == { judge_counts: { win: 1, lose: 0 } } }
    end

    it "exist?" do
      assert { @black.stat.xmode_judge_stat.exist?(:"指導", :win) }
    end

    it "count_by" do
      assert { @black.stat.xmode_judge_stat.count_by(:"指導", :win) == 1 }
    end

    it "ratio_by" do
      assert { @black.stat.xmode_judge_stat.ratio_by(:"指導", :win) == 1.0 }
    end

    it "counts_hash" do
      assert { @black.stat.xmode_judge_stat.counts_hash == { [:"指導", :win] => 1 } }
    end
  end

  describe "バッジ" do
    def case1(xmode_key, judge_key)
      Swars::Battle.create!(xmode_key: xmode_key) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
      end
    end

    it "友対GGマン" do
      @black = Swars::User.create!
      4.times { case1("友達", :lose) }
      4.times { case1("友達", :win) }
      assert { @black.stat.badge_stat.active?("友対GGマン") }
    end

    it "友対無双マン" do
      @black = Swars::User.create!
      8.times { case1("友達", :win) }
      assert { @black.stat.badge_stat.active?("友対無双マン") }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::XmodeJudgeStat
# >>   対局モードと勝敗
# >>     to_chart
# >>     exist?
# >>     count_by
# >>     ratio_by
# >>     counts_hash
# >>
# >> Swars::Top 5 slowest examples (1.23 seconds, 36.3% of total time):
# >>   Swars::User::Stat::XmodeJudgeStat 対局モードと勝敗 to_chart
# >>     0.60145 seconds -:17
# >>   Swars::User::Stat::XmodeJudgeStat 対局モードと勝敗 count_by
# >>     0.16859 seconds -:25
# >>   Swars::User::Stat::XmodeJudgeStat 対局モードと勝敗 counts_hash
# >>     0.15959 seconds -:33
# >>   Swars::User::Stat::XmodeJudgeStat 対局モードと勝敗 ratio_by
# >>     0.15075 seconds -:29
# >>   Swars::User::Stat::XmodeJudgeStat 対局モードと勝敗 exist?
# >>     0.14532 seconds -:21
# >>
# >> Swars::Finished in 3.37 seconds (files took 1.66 seconds to load)
# >> 5 examples, 0 failures
# >>
