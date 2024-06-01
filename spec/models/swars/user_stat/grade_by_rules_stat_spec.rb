require "rails_helper"

module Swars
  RSpec.describe UserStat::GradeByRulesStat, type: :model, swars_spec: true do
    describe "ルール別最高段級位" do
      before do
        @black = User.create!
      end

      def case1(rule_key, grade_key)
        @black.update!(grade_key: grade_key)
        Battle.create!(rule_key: rule_key) do |e|
          e.memberships.build(user: @black)
        end
      end

      it "works" do
        case1(:ten_min, "1級")
        case1(:ten_min, "2級")
        case1(:three_min, "3級")
        case1(:three_min, "4級")

        assert do
          @black.user_stat.grade_by_rules_stat.to_chart == [
            { :rule_key => :ten_min,   :rule_name => "10分", :grade_name => "1級", },
            { :rule_key => :three_min, :rule_name => "3分",  :grade_name => "3級", },
            { :rule_key => :ten_sec,   :rule_name => "10秒", :grade_name => nil,   },
          ]
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::GradeByRulesStat
# >>   ルール別最高段級位
# >>     works
# >> 
# >> Top 1 slowest examples (0.78487 seconds, 27.2% of total time):
# >>   Swars::UserStat::GradeByRulesStat ルール別最高段級位 works
# >>     0.78487 seconds -:17
# >> 
# >> Finished in 2.88 seconds (files took 1.55 seconds to load)
# >> 1 example, 0 failures
# >> 
