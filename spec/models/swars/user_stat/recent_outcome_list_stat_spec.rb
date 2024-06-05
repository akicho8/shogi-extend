require "rails_helper"

module Swars
  RSpec.describe UserStat::RecentOutcomeListStat, type: :model, swars_spec: true do
    describe "直近勝敗リスト" do
      def case1(battled_at, judge_key)
        Battle.create!(battled_at: battled_at) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
        end
        @black.user_stat.recent_outcome_list_stat.to_a
      end

      it "works" do
        @black = User.create!
        assert { case1("2000-01-01 00:01", :win)  == ["win"]         }
        assert { case1("2000-01-01 00:02", :lose) == ["win", "lose"] }
      end
    end
  end
end
