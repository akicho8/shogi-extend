require "rails_helper"

module Swars
  RSpec.describe UserStat::LethargyStat, type: :model, swars_spec: true do
    describe "無気力マン" do
      def case1(n, final_key)
        @black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.user_stat.lethargy_stat.exist?
      end

      it "works" do
        assert { case1(19, :TORYO)      }
        assert { case1(19, :CHECKMATE)  }
        assert { !case1(20, :CHECKMATE) }
        assert { !case1(19, :TIMEOUT)   }
        assert { !case1(20, :TIMEOUT)   }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UserStat::LethargyStat
# >>   無気力マン
# >>     works
# >> 
# >> Top 1 slowest examples (1.76 seconds, 46.1% of total time):
# >>   UserStat::LethargyStat 無気力マン works
# >>     1.76 seconds -:14
# >> 
# >> Finished in 3.81 seconds (files took 1.54 seconds to load)
# >> 1 example, 0 failures
# >> 
