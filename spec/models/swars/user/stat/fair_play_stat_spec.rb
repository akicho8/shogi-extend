require "rails_helper"

module Swars
  RSpec.describe User::Stat::FairPlayStat, type: :model, swars_spec: true do
    describe "マナー" do
      def case1
        @black = User.create!
        Battle.create! do |e|
          e.memberships.build(user: @black)
        end
      end

      xit "percentage_score" do
        case1
        assert { @black.stat.fair_play_stat.percentage_score == 100 }
      end

      xit "to_a" do
        case1
        tp @black.stat.fair_play_stat.to_a
      end
    end
  end
end
