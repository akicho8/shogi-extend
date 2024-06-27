require "rails_helper"

module Swars
  RSpec.describe StyleInfo, type: :model, swars_spec: true do
    it "works" do
      assert { StyleInfo.fetch("王道") }
    end
  end
end
