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

      describe "バッジ" do
        def case1(n)
          @black = User.create!
          Swars::Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :DRAW_SENNICHI) do |e|
            e.memberships.build(user: @black, judge_key: :draw)
          end
          @black.user_stat.badge_stat
        end

        it "開幕千日手" do
          assert { case1(12).active?(:"開幕千日手") }
        end

        it "ただの千日手" do
          assert { case1(50).active?(:"ただの千日手") }
        end
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
# >>     バッジ
# >>       開幕千日手
# >>       ただの千日手
# >> 
# >> Top 4 slowest examples (2.16 seconds, 50.7% of total time):
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 開幕千日手回数
# >>     1.2 seconds -:14
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 引き分け数
# >>     0.50682 seconds -:19
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 バッジ ただの千日手
# >>     0.24646 seconds -:37
# >>   Swars::UserStat::PerpetualCheckStat 開幕千日手回数 / 引き分け数 バッジ 開幕千日手
# >>     0.20018 seconds -:33
# >> 
# >> Finished in 4.25 seconds (files took 1.54 seconds to load)
# >> 4 examples, 0 failures
# >> 
