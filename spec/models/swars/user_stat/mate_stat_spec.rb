require "rails_helper"

module Swars
  RSpec.describe UserStat::MateStat, type: :model, swars_spec: true do
    describe "1手詰を焦らして悦に入った回数" do
      def case1(last_sec)
        @black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [0, 0, last_sec]), final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black)
        end
        user_stat = @black.user_stat
        [
          user_stat.mate_stat.to_chart,
          user_stat.mate_stat.max,
        ]
      end

      it "works" do
        assert { case1(44) == [nil, nil] }
        assert { case1(45) == [[{name: "45秒", value: 1}], 45] }
        assert { case1(60) == [[{name: "1分",  value: 1}], 60] }
        assert { case1(61) == [[{name: "1分",  value: 1}], 61] }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::MateStat
# >>   1手詰を焦らして悦に入った回数
# >>     works
# >> 
# >> Top 1 slowest examples (1.49 seconds, 41.8% of total time):
# >>   Swars::UserStat::MateStat 1手詰を焦らして悦に入った回数 works
# >>     1.49 seconds -:18
# >> 
# >> Finished in 3.56 seconds (files took 1.58 seconds to load)
# >> 1 example, 0 failures
# >> 
