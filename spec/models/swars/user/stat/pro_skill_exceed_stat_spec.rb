require "rails_helper"

RSpec.describe Swars::User::Stat::ProSkillExceedStat, type: :model, swars_spec: true do
  describe "指導の平手で勝った回数" do
    def case1(xmode_key, white_grade_key, preset_key, judge_key)
      preset_info = Bioshogi::PresetInfo.fetch(preset_key)
      kifu_body_for_test = preset_info.handicap ? "△34歩(33)" : "▲76歩(77)"
      @black = Swars::User.create!
      @white = Swars::User.create!(grade_key: white_grade_key)
      Swars::Battle.create!(xmode_key: xmode_key, preset_key: preset_key, kifu_body_for_test: kifu_body_for_test) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
        e.memberships.build(user: @white)
      end
      @black.stat.pro_skill_exceed_stat.counts_hash
    end

    it "works" do
      assert { case1("指導", "十段", "平手", :win)  == { win: 1 } }
      assert { case1("野良", "十段", "平手", :win)  == {} }
      assert { case1("指導", "九段", "平手", :win)  == { win: 1 } } # 相手の段級位をみていないため
      assert { case1("指導", "十段", "角落", :win)  == {} }
      assert { case1("指導", "十段", "平手", :lose) == {} }
    end
  end
end
