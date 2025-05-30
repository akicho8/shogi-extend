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

    it "段位を省略してもマッチする" do
      assert { Swars::GradeInfo.fetch("1") == Swars::GradeInfo.fetch("1級") }
      assert { Swars::GradeInfo.fetch("初") == Swars::GradeInfo.fetch("初段") }
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
end
