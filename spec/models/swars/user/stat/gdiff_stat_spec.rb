require "rails_helper"

module Swars
  RSpec.describe User::Stat::GdiffStat, type: :model, swars_spec: true do
    describe "対戦相手との段級差の平均" do
      def case1(black_grade_key, white_grade_key)
        @black.update!(grade_key: black_grade_key)
        @white.update!(grade_key: white_grade_key)
        Battle.create! do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.stat.gdiff_stat.average
      end

      it "works" do
        @black = User.create!
        @white = User.create!
        assert { case1("二段", "三段") == 1.0 }
        assert { case1("二段", "四段") == 1.5 }
      end

      it "works" do
        user = User.create!
        assert { user.stat.gdiff_stat.average == nil }
        assert { user.stat.gdiff_stat.abs     == nil }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::GdiffStat
# >>   対戦相手との段級差の平均
# >>     works
# >>
# >> Top 1 slowest examples (1.2 seconds, 36.7% of total time):
# >>   User::Stat::GdiffStat 対戦相手との段級差の平均 works
# >>     1.2 seconds -:21
# >>
# >> Finished in 3.27 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
