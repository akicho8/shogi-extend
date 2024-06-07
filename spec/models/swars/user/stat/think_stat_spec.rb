require "rails_helper"

module Swars
  RSpec.describe User::Stat::ThinkStat, type: :model, swars_spec: true do
    describe "最大思考 / 平均思考" do
      def case1
        @black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate(time_list: [10, 20])) do |e|
          e.memberships.build(user: @black)
        end
        [
          @black.stat.think_stat.max,
          @black.stat.think_stat.average,
        ]
      end

      it "works" do
        assert { case1 == [20, 15.0] }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> User::Stat::ThinkStat
# >>   最大思考 / 平均思考
# >>     works
# >> 
# >> Top 1 slowest examples (0.99267 seconds, 32.4% of total time):
# >>   User::Stat::ThinkStat 最大思考 / 平均思考 works
# >>     0.99267 seconds -:20
# >> 
# >> Finished in 3.06 seconds (files took 1.6 seconds to load)
# >> 1 example, 0 failures
# >> 
