require "rails_helper"

module Swars
  RSpec.describe UserStat::TaisekimatiStat, type: :model, swars_spec: true do
    describe "相手退席待ちマン" do
      before do
        @black = User.create!
        csa_seq = KifuGenerator.generate_n(16) + [["+5958OU", 300], ["-5152OU", 600], ["+5859OU", 1], ["-5251OU", 600]]
        Swars::Battle.create!(csa_seq: csa_seq, final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
      end

      it "count" do
        assert { @black.user_stat.taisekimati_stat.count == 1 }
      end

      it "medal" do
        assert { @black.user_stat.medal_stat.active?("相手退席待ちマン") }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::UserStat::ThinkStat
# >>   相手退席待ちマン
# >>     works
# >>
# >> Top 1 slowest examples (1.06 seconds, 33.8% of total time):
# >>   Swars::UserStat::ThinkStat 相手退席待ちマン works
# >>     1.06 seconds -:15
# >>
# >> Finished in 3.13 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
