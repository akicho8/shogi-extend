require "rails_helper"

module Swars
  RSpec.describe UserStat::PieceStat, type: :model, swars_spec: true do
    def case1
      user = User.create!
      Battle.create!(csa_seq: KifuGenerator.generate_n(3)) do |e|
        e.memberships.build(user: user)
      end
      items = user.user_stat.piece_stat.to_chart
      items.reject { |e| e[:value].zero? }
    end

    it "駒の使用頻度" do
      assert { case1 == [{name: "玉", value: 1.0}] }
    end
  end
end
