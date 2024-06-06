require "rails_helper"

module Swars
  RSpec.describe UserStat::GdiffStat, type: :model, swars_spec: true do
    describe "対戦相手との段級差の平均" do
      def case1(black_grade_key, white_grade_key)
        @black.update!(grade_key: black_grade_key)
        @white.update!(grade_key: white_grade_key)
        Battle.create! do |e|
          e.memberships.build(user: @black)
          e.memberships.build(user: @white)
        end
        @black.user_stat.gdiff_stat.average
      end

      it "works" do
        @black = User.create!
        @white = User.create!
        assert { case1("二段", "三段") == 1.0 }
        assert { case1("二段", "四段") == 1.5 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::GdiffStat
# >>   対戦相手との段級差の平均
# >>     works
# >> 
# >> Top 1 slowest examples (1.2 seconds, 36.7% of total time):
# >>   UserStat::GdiffStat 対戦相手との段級差の平均 works
# >>     1.2 seconds -:21
# >> 
# >> Finished in 3.27 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >> 
