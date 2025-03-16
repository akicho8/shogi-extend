require "rails_helper"

RSpec.describe Swars::User::Stat::WaitingToLeaveStat, type: :model, swars_spec: true do
  describe "相手退席待ちマン" do
    def case1
      @black = Swars::User.create!
      csa_seq = Swars::KifuGenerator.generate_n(16) + [["+5958OU", 300], ["-5152OU", 600], ["+5859OU", 1], ["-5251OU", 600]]
      Swars::Battle.create!(csa_seq: csa_seq, final_key: :CHECKMATE) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
      end
    end

    it "count" do
      case1
      assert { @black.stat.waiting_to_leave_stat.count == 1 }
    end

    it "badge" do
      case1
      assert { @black.stat.badge_stat.active?("相手退席待ちマン") }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::ThinkStat
# >>   相手退席待ちマン
# >>     works
# >>
# >> Swars::Top 1 slowest examples (1.06 seconds, 33.8% of total time):
# >>   Swars::User::Stat::ThinkStat 相手退席待ちマン works
# >>     1.06 seconds -:15
# >>
# >> Swars::Finished in 3.13 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
