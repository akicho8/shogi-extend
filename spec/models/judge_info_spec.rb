require "rails_helper"

RSpec.describe JudgeInfo do
  it "flip" do
    assert { JudgeInfo[:win].flip.key == :lose }
    assert { JudgeInfo[:draw].flip.key == :draw }
  end

  it "fetch" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo["勝ち"] == win }
    assert { JudgeInfo["○"]   == win }
    assert { JudgeInfo["勝"]   == win }
  end

  it "winをWinと入力する人がいる対策" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo[:Win]  == win }
    assert { JudgeInfo["Win"]  == win }
    assert { JudgeInfo["WIN"]  == win }
  end
end
