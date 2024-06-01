require "rails_helper"

module Swars
  RSpec.describe UserStat::LeaveAloneStat, type: :model, swars_spec: true do
    describe "投了せずに放置した回数 / 投了せずに放置した時間" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        user_stat = @black.user_stat
        [
          user_stat.leave_alone_stat.to_chart,
          user_stat.leave_alone_stat.max,
        ]
      end

      it "works" do
        assert { case1(13) == [nil, nil] }
        assert { case1(14) == [[{name: "10分", value: 1}], 600] }
        assert { case1(15) == [[{name: "10分", value: 2}], 600] }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::LeaveAloneStat
# >>   投了せずに放置した回数 / 投了せずに放置した時間
# >>     works
# >> 
# >> Top 1 slowest examples (1.35 seconds, 39.5% of total time):
# >>   Swars::UserStat::LeaveAloneStat 投了せずに放置した回数 / 投了せずに放置した時間 works
# >>     1.35 seconds -:21
# >> 
# >> Finished in 3.42 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >> 
