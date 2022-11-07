require "rails_helper"

module Swars
  RSpec.describe KeyGenerator, type: :model, swars_spec: true do
    it "generate" do
      KeyGenerator.generate == KeyVo.wrap("alice-bob-20000101_000000")
    end
    it "seed" do
      KeyGenerator.generate(seed: 62) == KeyVo.wrap("alice-bob-20000101_000101")
    end
  end
end

