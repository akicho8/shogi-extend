require "rails_helper"

module Swars
  RSpec.describe RarityInfo, type: :model, swars_spec: true do
    it "style_info" do
      assert { RarityInfo.first.style_info }
    end

    it "StyleInfoと対応しているため同じキーで引ける" do
      assert { RarityInfo.fetch("王道").key == :rarity_key_N }
    end
  end
end
