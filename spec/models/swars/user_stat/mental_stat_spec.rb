require "rails_helper"

module Swars
  RSpec.describe UserStat::MentalStat, type: :model, swars_spec: true do
    describe "不屈の闘志" do
      before do
        @black = User.create!
      end

      def case1(n, judge_key)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "works" do
        case1(100, :win)
        case1(110, :lose)
        assert { @black.user_stat.mental_stat.raw_level == 10.0 }
        assert { @black.user_stat.mental_stat.level == 5 }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MentalStat
# >>   不屈の闘志
# >>     works
# >> 
# >> Top 1 slowest examples (0.69039 seconds, 24.7% of total time):
# >>   Swars::UserStat::MentalStat 不屈の闘志 works
# >>     0.69039 seconds -:16
# >> 
# >> Finished in 2.8 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
