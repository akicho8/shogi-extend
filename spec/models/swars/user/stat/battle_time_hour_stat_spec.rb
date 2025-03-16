require "rails_helper"

RSpec.describe "対局時間帯", type: :model, swars_spec: true do
  def case1(battled_at)
    black = Swars::User.create!
    Swars::Battle.create!(battled_at: battled_at) do |e|
      e.memberships.build(user: black)
    end
    av = black.stat.battle_time_hour_stat.to_chart
    av.find { |e| e[:value].positive? }.fetch(:name)
  end

  it "works" do
    assert { case1("2000-01-01 00:59") == "0" }
    assert { case1("2000-01-01 01:00") == "1" }
  end
end
