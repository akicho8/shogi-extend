require "rails_helper"

module Swars
  RSpec.describe FinalInfo, type: :model, swars_spec: true do
    it "通信不調で切断が引ける" do
      assert { FinalInfo["通信不調"].name == "切断" }
    end
  end
end
