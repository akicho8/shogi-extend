require "rails_helper"

RSpec.describe JudgeInfo do
  it "flip" do
    assert { JudgeInfo[:win].flip.key == :lose }
    assert { JudgeInfo[:draw].flip.key == :draw }
  end
end
