require "rails_helper"

module Swars
  RSpec.describe UserStat::FinalStat, type: :model, swars_spec: true do
    describe "勝ち負け時の結末の内訳" do
      before do
        @black = User.create!
      end

      def case1(final_key, judge_key)
        Battle.create!(final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
      end

      it "works" do
        case1(:CHECKMATE, :win)
        case1(:TORYO,     :win)
        case1(:CHECKMATE, :lose)

        assert do
          @black.user_stat.final_stat.to_chart(:win) == [
            {:key => :TORYO,     :name => "投了",     :value => 1},
            {:key => :TIMEOUT,   :name => "時間切れ", :value => 0},
            {:key => :CHECKMATE, :name => "詰み",     :value => 1},
          ]
        end
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::FinalStat
# >>   勝ち負け時の結末の内訳
# >>     works
# >> 
# >> Top 1 slowest examples (0.70945 seconds, 25.3% of total time):
# >>   Swars::UserStat::FinalStat 勝ち負け時の結末の内訳 works
# >>     0.70945 seconds -:16
# >> 
# >> Finished in 2.8 seconds (files took 1.57 seconds to load)
# >> 1 example, 0 failures
# >> 
