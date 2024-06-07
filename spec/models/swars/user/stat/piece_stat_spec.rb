require "rails_helper"

module Swars
  RSpec.describe User::Stat::PieceStat, type: :model, swars_spec: true do
    def case1
      user = User.create!
      Battle.create!(csa_seq: KifuGenerator.generate_n(3)) do |e|
        e.memberships.build(user: user)
      end
      items = user.stat.piece_stat.to_chart
      items.reject { |e| e[:value].zero? }
    end

    it "駒の使用頻度" do
      assert { case1 == [{name: "玉", value: 1.0}] }
    end
  end
end

# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> User::Stat::PieceStat
# >>   駒の使用頻度
# >> 
# >> Top 1 slowest examples (0.99612 seconds, 30.4% of total time):
# >>   User::Stat::PieceStat 駒の使用頻度
# >>     0.99612 seconds -:14
# >> 
# >> Finished in 3.28 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >> 
