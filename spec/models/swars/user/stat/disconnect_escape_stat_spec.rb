require "rails_helper"

module Swars
  RSpec.describe User::Stat::DisconnectEscapeStat, type: :model, swars_spec: true do
    describe "切断逃亡" do
      def case1(n)
        Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
        end
        @black.stat.disconnect_escape_stat.positive_count
      end

      it "works" do
        @black = User.create!
        assert { case1(13) == nil }
        assert { case1(14) == 1 }
        assert { case1(14) == 2 }
      end
    end
  end
end
