require "rails_helper"

module Swars
  RSpec.describe BattleKeyGenerator, type: :model, swars_spec: true do
    it "generate" do
      assert { BattleKeyGenerator.new.generate.kind_of? BattleKey }
    end
  end
end
