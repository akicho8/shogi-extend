require "rails_helper"

RSpec.describe Swars::User::Stat::SkillAdjustStat, type: :model, swars_spec: true do
  describe "棋力調整マン" do
    def case1(n, final_key)
      @black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: final_key) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
      end
      @black.stat.skill_adjust_stat.count.positive?
    end

    it "works" do
      assert { case1(13, :TORYO) == true  }
      assert { case1(14, :TORYO) == false }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::SkillAdjustStat
# >>   無気力マン
# >>     works
# >>
# >> Swars::Top 1 slowest examples (1.54 seconds, 41.8% of total time):
# >>   Swars::User::Stat::SkillAdjustStat 無気力マン works
# >>     1.54 seconds -:14
# >>
# >> Swars::Finished in 3.68 seconds (files took 2.04 seconds to load)
# >> 1 example, 0 failures
# >>
