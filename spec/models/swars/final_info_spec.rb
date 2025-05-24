require "rails_helper"

RSpec.describe Swars::FinalInfo, type: :model, swars_spec: true do
  it "通信不調で切断が引ける" do
    assert { Swars::FinalInfo.fetch("通信不調").name == "切断" }
    assert { Swars::FinalInfo.fetch(:"通信不調").name == "切断" }
  end
end
