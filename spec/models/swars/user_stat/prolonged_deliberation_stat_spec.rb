require "rails_helper"

module Swars
  RSpec.describe UserStat::OverthinkingLossStat, type: :model, swars_spec: true do
    describe "大長考マン" do
      def case1(min)
        seconds = min.minutes
        @black = User.create!
        csa_seq = [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]]
        Swars::Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        @black.user_stat.medal_stat.to_set
      end

      it "works" do
        assert { case1(2.5).exclude?(:"大長考マン") }
        assert { case1(3.0).include?(:"大長考マン") }
      end
    end
  end
end
