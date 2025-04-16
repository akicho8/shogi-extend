require "rails_helper"

RSpec.describe JudgeInfo do
  it ".fetch" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo["勝ち"] == win }
    assert { JudgeInfo["○"]   == win }
    assert { JudgeInfo["勝"]   == win }
  end

  it ".zero_default_hash" do
    assert { JudgeInfo.zero_default_hash == { win: 0, lose: 0, draw: 0 } }
  end

  it ".zero_default_hash_wrap" do
    assert { JudgeInfo.zero_default_hash_wrap({ "win" => 1 }) == { win: 1, lose: 0, draw: 0 } }
  end

  it "#flip" do
    assert { JudgeInfo[:win].flip.key == :lose }
    assert { JudgeInfo[:draw].flip.key == :draw }
  end

  it "winをWinと入力する人がいる対策" do
    win = JudgeInfo.fetch(:win)
    assert { JudgeInfo[:Win]  == win }
    assert { JudgeInfo["Win"]  == win }
    assert { JudgeInfo["WIN"]  == win }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> JudgeInfo
# >>   .fetch
# >>   .zero_default_hash
# >>   .zero_default_hash_wrap
# >>   #flip
# >>   winをWinと入力する人がいる対策
# >>
# >> Top 5 slowest examples (0.10867 seconds, 5.0% of total time):
# >>   JudgeInfo .fetch
# >>     0.07195 seconds -:4
# >>   JudgeInfo winをWinと入力する人がいる対策
# >>     0.0161 seconds -:24
# >>   JudgeInfo #flip
# >>     0.00978 seconds -:19
# >>   JudgeInfo .zero_default_hash
# >>     0.0055 seconds -:11
# >>   JudgeInfo .zero_default_hash_wrap
# >>     0.00535 seconds -:15
# >>
# >> Finished in 2.18 seconds (files took 1.57 seconds to load)
# >> 5 examples, 0 failures
# >>
