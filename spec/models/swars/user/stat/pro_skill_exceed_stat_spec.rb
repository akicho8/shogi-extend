require "rails_helper"

RSpec.describe Swars::User::Stat::ProSkillExceedStat, type: :model, swars_spec: true do
  describe "指導の平手で勝った回数" do
    def case1(xmode_key, white_grade_key, preset_key, judge_key)
      @black = Swars::User.create!
      @white = Swars::User.create!(grade_key: white_grade_key)
      Swars::Battle.create!(xmode_key: xmode_key, preset_key: preset_key) do |e|
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
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::ProSkillExceedStat
# >>   指導の平手で勝った回数
# >>     works
# >>
# >> Swars::Top 1 slowest examples (1.62 seconds, 43.4% of total time):
# >>   Swars::User::Stat::ProSkillExceedStat 指導の平手で勝った回数 works
# >>     1.62 seconds -:16
# >>
# >> Swars::Finished in 3.72 seconds (files took 2.07 seconds to load)
# >> 1 example, 0 failures
# >>
