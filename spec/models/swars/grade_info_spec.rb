require "rails_helper"

RSpec.describe Swars::GradeInfo, type: :model, swars_spec: true do
  describe "曖昧入力" do
    it "works" do
      assert { Swars::GradeInfo["一五級"].name == "15級" }
      assert { Swars::GradeInfo["十五級"].name == "15級" }
      assert { Swars::GradeInfo["十級"].name   == "10級" }
      assert { Swars::GradeInfo["一級"].name   == "1級"  }
      assert { Swars::GradeInfo["一段"].name   == "初段" }
      assert { Swars::GradeInfo["1段"].name    == "初段" }
      assert { Swars::GradeInfo["2段"].name    == "二段" }
      assert { Swars::GradeInfo["10段"].name   == "十段" }
      assert { Swars::GradeInfo["１０段"].name == "十段" }
    end

    it "段位を省略したものをマッチさせてはいけない (ウォーズIDとして使っている場合もあるため曖昧な数値文字列を級位に自動変換してはいけない)" do
      assert { !Swars::GradeInfo.lookup("1") }
      assert { !Swars::GradeInfo.lookup("初") }

      assert { !Swars::GradeInfo["443443443"] }
      assert { !Swars::GradeInfo["2024_0203"] }
    end
  end

  describe "垢BAN" do
    it "30級より低い場合はすべて垢BAN扱いとする" do
      assert { Swars::GradeInfo.fetch("30級") == Swars::GradeInfo.fetch("30級") }
      assert { Swars::GradeInfo.fetch("31級") == Swars::GradeInfo.ban }
    end

    it "垢BANは10000級" do
      assert { Swars::GradeInfo.ban.key == :"10000級" }
    end

    it "9999級も元は10000級" do
      assert { Swars::GradeInfo.fetch("9999級").ban? }
    end
  end

  it "score" do
    assert { Swars::GradeInfo["十段"].score    == 40 }
    assert { Swars::GradeInfo["九段"].score    == 39 }
    assert { Swars::GradeInfo["10000級"].score == 0  }
  end
end
