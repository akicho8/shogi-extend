require "rails_helper"

RSpec.describe Swars::User::Stat::RuleStat, type: :model, swars_spec: true do
  describe "時間別対局頻度" do
    def case1(rule_key)
      csa_seq = Swars::KifuGenerator.generate_n(0, rule_key: rule_key)
      Swars::Battle.create!(rule_key: rule_key, csa_seq: csa_seq) do |e|
        e.memberships.build(user: @black)
      end
    end

    it "works" do
      @black = Swars::User.create!

      case1(:ten_min)
      case1(:three_min)
      case1(:ten_sec)

      outcome = [
        { :name => "10分", :value => 1 },
        { :name => "3分",  :value => 1 },
        { :name => "10秒", :value => 1 },
      ]

      assert { @black.stat.rule_stat.to_chart == outcome }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::RuleStat
# >>   時間別対局頻度
# >>     works
# >>
# >> Swars::Top 1 slowest examples (0.57971 seconds, 21.6% of total time):
# >>   Swars::User::Stat::RuleStat 時間別対局頻度 works
# >>     0.57971 seconds -:17
# >>
# >> Swars::Finished in 2.68 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
