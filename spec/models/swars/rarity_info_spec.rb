require "rails_helper"

module Swars
  RSpec.describe RarityInfo, type: :model, swars_spec: true do
    it "style_info" do
      is_asserted_by { RarityInfo.first.style_info }
    end
  end
end
