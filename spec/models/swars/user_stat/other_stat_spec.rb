require "rails_helper"

module Swars
  RSpec.describe UserStat::OtherStat, type: :model, swars_spec: true do
    describe "他" do
      def case1
        @black = User.create!
        Battle.create! do |e|
          e.memberships.build(user: @black)
        end
      end
      it "works" do
        case1
        assert { @black.user_stat.other_stat.to_a       }
        assert { @black.user_stat.other_stat.time_stats }
      end
    end
  end
end
