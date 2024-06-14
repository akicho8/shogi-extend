require "rails_helper"

module Swars
  RSpec.describe User::Stat::NamepuStat, type: :model, swars_spec: true do
    describe "舐めプ戦法回数" do
      def case1
        @black = User.create!
        Battle.create!(tactic_key: "穴角戦法") do |e|
          e.memberships.build(user: @black)
        end
      end

      it "namepu_count" do
        case1
        assert { @black.stat.namepu_stat.namepu_count > 0 }
      end

      it ".report" do
        assert { User::Stat::NamepuStat.report }
      end
    end
  end
end
