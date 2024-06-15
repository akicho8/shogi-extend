require "rails_helper"

module Swars
  RSpec.describe User::Stat::BadTacticStat, type: :model, swars_spec: true do
    describe "舐めプ戦法回数" do
      def case1
        @black = User.create!
        Battle.create!(tactic_key: "穴角戦法") do |e|
          e.memberships.build(user: @black)
        end
      end

      it "bad_tactic_count" do
        case1
        assert { @black.stat.bad_tactic_stat.bad_tactic_count > 0 }
      end

      it ".report" do
        assert { User::Stat::BadTacticStat.report }
      end
    end
  end
end
