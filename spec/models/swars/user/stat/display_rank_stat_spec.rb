require "rails_helper"

RSpec.describe Swars::User::Stat::DisplayRankStat, type: :model, swars_spec: true do
  describe "ルール別最高段級位" do
    def case1(rule_key, grade_key)
      @black.update!(grade_key: grade_key)
      Swars::Battle.create!(rule_key: rule_key) do |e|
        e.memberships.build(user: @black)
      end
    end

    it "works" do
      @black = Swars::User.create!
      case1(:ten_min, "1級")
      case1(:ten_min, "2級")
      case1(:three_min, "3級")
      case1(:three_min, "4級")

      assert do
        @black.stat.display_rank_stat.display_ranks == [
          { key: :display_rank_ten_min, short_name: "10分", search_params: { "開始モード" => "通常", "持ち時間" => "10分" }, grade_name: "1級" },
          { key: :display_rank_three_min, short_name: "3分", search_params: { "開始モード" => "通常", "持ち時間" => "3分" }, grade_name: "3級" },
          { key: :display_rank_ten_sec, short_name: "10秒", search_params: { "開始モード" => "通常", "持ち時間" => "10秒" }, grade_name: nil },
          { key: :display_rank_sprint, short_name: "ス", search_params: { "開始モード" => "スプリント" }, grade_name: nil },
        ]
      end
    end
  end
end
