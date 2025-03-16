require "rails_helper"

RSpec.describe Swars::GradeInfo, type: :model, swars_spec: true do
  it "段位を数字で入力する人がいるため仕方なく許容する" do
    assert { Swars::GradeInfo.lookup("9段") == Swars::GradeInfo.fetch("九段") }
    assert { Swars::GradeInfo.lookup("９段") == Swars::GradeInfo.fetch("九段") }
    assert { Swars::GradeInfo.lookup("１０段") == Swars::GradeInfo.fetch("十段") }
  end

  it "段位を省略してもマッチする" do
    assert { Swars::GradeInfo.fetch("1") == Swars::GradeInfo.fetch("1級") }
    assert { Swars::GradeInfo.fetch("初") == Swars::GradeInfo.fetch("初段") }
  end

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
