require "rails_helper"

module Swars
  RSpec.describe GradeInfo, type: :model, swars_spec: true do
    it "段位を数字で入力する人がいるため仕方なく許容する" do
      assert { GradeInfo.lookup("9段") == GradeInfo.fetch("九段") }
      assert { GradeInfo.lookup("９段") == GradeInfo.fetch("九段") }
      assert { GradeInfo.lookup("１０段") == GradeInfo.fetch("十段") }
    end

    it "段位を省略してもマッチする" do
      assert { GradeInfo.fetch("1") == GradeInfo.fetch("1級") }
      assert { GradeInfo.fetch("初") == GradeInfo.fetch("初段") }
    end

    it "30級より低い場合はすべて垢BAN扱いとする" do
      assert { GradeInfo.fetch("30級") == GradeInfo.fetch("30級") }
      assert { GradeInfo.fetch("31級") == GradeInfo.ban }
    end

    it "垢BANは10000級" do
      assert { GradeInfo.ban.key == :"10000級" }
    end
  end
end
