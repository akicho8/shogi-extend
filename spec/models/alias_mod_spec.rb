require "rails_helper"

RSpec.describe AliasMod do
  it "works" do
    assert { JudgeInfo["△"] }
  end
end
