require "rails_helper"

module Swars
  RSpec.describe StyleInfo, type: :model, swars_spec: true do
    it "rarity_info" do
      assert { StyleInfo.first.rarity_info }
    end
  end
end
