require "rails_helper"

module Swars
  RSpec.describe User::Stat::NoteStat, type: :model, swars_spec: true do
    def case1(csa_seq)
      user = User.create!
      battle = Battle.create!(csa_seq: csa_seq) do |e|
        e.memberships.build(user: user)
      end
      user.stat.note_stat.to_chart("居飛車")
    end

    it "居飛車・振り飛車での勝敗数" do
      assert { case1(KifuGenerator.furi_pattern(14)) == nil }
      assert { case1(KifuGenerator.ibis_pattern(14)) == { judge_counts: { "win" => 1 } } }
    end
  end
end
