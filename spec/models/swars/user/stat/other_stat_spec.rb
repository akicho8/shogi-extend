require "rails_helper"

module Swars
  RSpec.describe User::Stat::OtherStat, type: :model, swars_spec: true do
    describe "他" do
      def case1
        @black = User.create!
        Battle.create! do |e|
          e.memberships.build(user: @black)
        end
      end
      it "works" do
        case1
        assert { @black.stat.other_stat.to_a       }
        assert { @black.stat.other_stat.time_stats }
      end
    end
  end
end
