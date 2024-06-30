require "rails_helper"

module Swars
  RSpec.describe User::Stat::DrawStat, type: :model, swars_spec: true do
    describe "開幕千日手 / 通常の千日手" do
      def case1(n)
        black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
          e.memberships.build(user: black, judge_key: :draw)
        end
        black.stat.draw_stat
      end

      it "開幕千日手" do
        assert { case1(11).rigging_count == 0 }
        assert { case1(12).rigging_count == 1 }
      end

      it "通常の千日手" do
        assert { case1(12).normal_count == 0 }
        assert { case1(13).normal_count == 1 }
      end
    end

    describe "先手の千日手" do
      def case1(location_key)
        black = User.create!
        Battle.create!(csa_seq: KifuGenerator.generate_n(37 + 1)) do |e|
          e.memberships.build(user: black, judge_key: :draw, location_key: location_key)
        end
        black.stat.draw_stat.black_sennichi_count
      end

      it "works" do
        assert { case1(:black) == 1 }
        assert { case1(:white) == 0 }
      end
    end
  end
end
