require "rails_helper"

module Swars
  RSpec.describe UserStat::XmodeStat, type: :model, swars_spec: true do
    describe "対局モード" do
      before do
        @black = User.create!
      end

      def case1(xmode_key)
        Battle.create!(xmode_key: xmode_key) do |e|
          e.memberships.build(user: @black)
        end
      end

      it "works" do
        case1(:"野良")
        case1(:"友達")
        case1(:"指導")
        assert do
          @black.user_stat.xmode_stat.to_chart == [
            {:name => "野良", :value => 1},
            {:name => "友達", :value => 1},
            {:name => "指導", :value => 1},
          ]
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::XmodeStat
# >>   対局モード
# >>     works
# >> 
# >> Top 1 slowest examples (0.71583 seconds, 21.6% of total time):
# >>   Swars::UserStat::XmodeStat 対局モード works
# >>     0.71583 seconds -:16
# >> 
# >> Finished in 3.32 seconds (files took 1.57 seconds to load)
# >> 1 example, 0 failures
# >> 
