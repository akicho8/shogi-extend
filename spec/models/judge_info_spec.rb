require "rails_helper"

RSpec.describe JudgeInfo do
  it "flip" do
    is_asserted_by { JudgeInfo[:win].flip.key == :lose }
    is_asserted_by { JudgeInfo[:draw].flip.key == :draw }
  end

  it "fetch" do
    win = JudgeInfo.fetch(:win)
    is_asserted_by { JudgeInfo["勝ち"] == win }
    is_asserted_by { JudgeInfo["○"]   == win }
  end

  it "winをWinと入力する人がいる対策" do
    win = JudgeInfo.fetch(:win)
    is_asserted_by { JudgeInfo[:Win]  == win }
    is_asserted_by { JudgeInfo["Win"]  == win }
    is_asserted_by { JudgeInfo["WIN"]  == win }
  end
end
