require "rails_helper"

RSpec.describe Swars::FinalInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::FinalInfo.fetch("切断") }
  end

  it "通信不調で切断が引ける" do
    assert { Swars::FinalInfo.fetch("通信不調") }
    assert { Swars::FinalInfo.fetch(:"通信不調") }
  end
end
