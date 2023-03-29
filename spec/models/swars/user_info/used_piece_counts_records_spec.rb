require "rails_helper"

module Swars
  RSpec.describe "駒の使用率", type: :model, swars_spec: true do
    before do
      @black = User.create!
    end

    def case1(battled_at)
      Battle.create!(battled_at: battled_at) do |e|
        e.memberships.build(user: @black)
      end
      @black.user_info.battle_count_per_hour_records.to_chart.find_all { |e| e[:value].positive? }
    end

    it "works" do
      assert2 { case1("2000-01-01 00:00") == [{name: "0", value: 1}] }
      assert2 { case1("2000-01-01 00:59") == [{name: "0", value: 2}] }
      assert2 { case1("2000-01-01 01:00") == [{name: "0", value: 2}, {name: "1", value: 1}] }
    end
  end
end
