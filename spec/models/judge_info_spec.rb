require "rails_helper"

RSpec.describe JudgeInfo do
  it "flip" do
    assert2 { JudgeInfo[:win].flip.key == :lose }
    assert2 { JudgeInfo[:draw].flip.key == :draw }
  end

  it "fetch" do
    win = JudgeInfo.fetch(:win)
    assert2 { JudgeInfo["勝ち"] == win }
    assert2 { JudgeInfo["○"]   == win }
  end

  it "winをWinと入力する人がいる対策" do
    win = JudgeInfo.fetch(:win)
    assert2 { JudgeInfo[:Win]  == win }
    assert2 { JudgeInfo["Win"]  == win }
    assert2 { JudgeInfo["WIN"]  == win }
  end
end
