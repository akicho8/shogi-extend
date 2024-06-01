require "rails_helper"

module Swars
  RSpec.describe UserStat::CheckmateDelayEnjoymentStat, type: :model, swars_spec: true do
    describe "切断逃亡" do
      before do
        @black = User.create!
      end

      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.user_stat.checkmate_delay_enjoyment_stat.positive_count
      end

      it "works" do
        assert { case1(13) == nil }
        assert { case1(14) == 1 }
        assert { case1(14) == 2 }
      end
    end
  end
end
