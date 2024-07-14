require "rails_helper"

module Swars
  RSpec.describe User::Stat::VitalityStat, type: :model, swars_spec: true do
    describe "勢い" do
      def case1(n)
        black = User.create!
        n.times do
          Battle.create! do |e|
            e.memberships.build(user: black)
          end
        end
        black.stat.vitality_stat
      end

      it "works" do
        assert { case1(0).level == 0.0 }
        assert { case1(1).level == 0.2 }
      end
    end
  end
end
