require "rails_helper"

module Swars
  RSpec.describe UserStat::TagStat, type: :model, swars_spec: true do
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
