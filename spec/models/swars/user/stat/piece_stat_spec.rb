require "rails_helper"

RSpec.describe Swars::User::Stat::PieceStat, type: :model, swars_spec: true do
  def case1
    user = Swars::User.create!
    Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(3)) do |e|
      e.memberships.build(user: user)
    end
    items = user.stat.piece_stat.to_chart
    items.reject { |e| e[:value].zero? }
  end

  it "駒の使用頻度" do
    assert { case1 == [{ name: "玉", value: 1.0 }] }
  end
end

# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::PieceStat
# >>   駒の使用頻度
# >>
# >> Swars::Top 1 slowest examples (0.99612 seconds, 30.4% of total time):
# >>   Swars::User::Stat::PieceStat 駒の使用頻度
# >>     0.99612 seconds -:14
# >>
# >> Swars::Finished in 3.28 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >>
