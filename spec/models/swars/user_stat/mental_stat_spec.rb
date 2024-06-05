require "rails_helper"

module Swars
  RSpec.describe UserStat::MentalStat, type: :model, swars_spec: true do
    describe "不屈の闘志" do
      def case1(n, judge_key)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "works" do
        @black = User.create!
        case1(100, :win)
        case1(110, :lose)
        assert { @black.user_stat.mental_stat.raw_level == 10.0 }
        assert { @black.user_stat.mental_stat.level == 5 }
        assert { @black.user_stat.mental_stat.hard_brain? }
      end

      it ".report" do
        assert { UserStat::MentalStat.report }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::UserStat::MentalStat
# >>   report
# >>   不屈の闘志
# >>     works
# >>
# >> Top 2 slowest examples (0.81982 seconds, 28.4% of total time):
# >>   Swars::UserStat::MentalStat 不屈の闘志 works
# >>     0.63995 seconds -:12
# >>   Swars::UserStat::MentalStat report
# >>     0.17987 seconds -:22
# >>
# >> Finished in 2.89 seconds (files took 1.55 seconds to load)
# >> 2 examples, 0 failures
# >>
