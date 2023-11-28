require "rails_helper"

module Swars
  RSpec.describe BanInfo, type: :model, swars_spec: true do
    it "works" do
      assert { BanInfo["on"] }
      assert { BanInfo["true"] }
    end
  end
end
