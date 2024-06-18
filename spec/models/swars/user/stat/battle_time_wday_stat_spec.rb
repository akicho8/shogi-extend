require "rails_helper"

module Swars
  RSpec.describe "対局曜日", type: :model, swars_spec: true do
    def case1(battled_at)
      black = User.create!
      Battle.create!(battled_at: battled_at) do |e|
        e.memberships.build(user: black)
      end
      av = black.stat.battle_time_wday_stat.to_chart
      av.find { |e| e[:value].positive? }.fetch(:name)
    end

    it "works" do
      assert { case1("2024-06-18 02:59") == "月" }
      assert { case1("2024-06-18 03:00") == "火" }
    end
  end
end
