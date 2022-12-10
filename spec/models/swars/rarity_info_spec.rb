require "rails_helper"

module Swars
  RSpec.describe RarityInfo, type: :model, swars_spec: true do
    it "works" do
      assert { RarityInfo.fetch("SR").key == :super_rare }
    end
  end
end
