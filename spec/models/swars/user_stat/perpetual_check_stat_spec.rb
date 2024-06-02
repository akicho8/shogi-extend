require "rails_helper"

module Swars
  RSpec.describe UserStat::PerpetualCheckStat, type: :model, swars_spec: true do
    describe "開幕千日手回数 / 引き分け数" do
      def case1(n)
        black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: black, judge_key: :draw)
        end
        black.user_stat.perpetual_check_stat
      end

      it "開幕千日手回数" do
        assert { case1(11).opening_repetition_move_count == 0 }
        assert { case1(12).opening_repetition_move_count == 1 }
      end

      it "引き分け数" do
        assert { case1(49).over50_draw_count == 0 }
        assert { case1(50).over50_draw_count == 1 }
      end
    end
  end
end

# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> Swars::UserStat::PerpetualCheckStat
# >>   開幕千日手回数 / 引き分け数
# >>     開幕千日手回数
# >>     引き分け数
# >> 
# >> Top 2 slowest examples (1.67 seconds, 44.9% of total time):
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 開幕千日手回数
# >>     1.17 seconds -:14
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 引き分け数
# >>     0.50633 seconds -:19
# >> 
# >> Finished in 3.73 seconds (files took 1.56 seconds to load)
# >> 2 examples, 0 failures
# >> 
