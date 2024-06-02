require "rails_helper"

module Swars
  RSpec.describe "100手勝ちマン", type: :model, swars_spec: true do
    def case1(n)
      user = User.create!
      Swars::Battle.create!(csa_seq: KifuGenerator.generate_n(n)) do |e|
        e.memberships.build(user: user, judge_key: :win)
      end
      user.user_stat.medal_stat.to_set.include?(:"100手勝ちマン")
    end

    xit "works" do
      assert { case1(99)  == false }
      assert { case1(100) == true  }
      assert { case1(101) == false }
    end
  end
end
