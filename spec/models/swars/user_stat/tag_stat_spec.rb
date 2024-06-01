require "rails_helper"

module Swars
  RSpec.describe UserStat::TagStat, type: :model, swars_spec: true do
    describe "派閥" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.all_tag.to_chart([:"居飛車", :"振り飛車"]).collect { |e| e[:value] }
      end

      it "works" do
        assert { case1(KifuGenerator.ibis_pattern) == [1, 0] }
        assert { case1(KifuGenerator.furi_pattern) == [1, 1] }
        assert { case1(KifuGenerator.furi_pattern) == [1, 2] }
      end
    end

    describe "不成シリーズ" do
      def case1(tactic_key)
        black = User.create!
        Battle.create!(tactic_key: tactic_key) do |e|
          e.memberships.build(user: black)
        end
        black
      end

      it "角不成" do
        assert { case1("角不成").user_stat.all_tag.to_h[:"角不成"] >= 1 }
      end

      it "飛車不成" do
        assert { case1("飛車不成").user_stat.all_tag.to_h[:"飛車不成"] >= 1 }
      end
    end
  end
end
