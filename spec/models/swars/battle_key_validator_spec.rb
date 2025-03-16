require "rails_helper"

RSpec.describe Swars::BattleKeyValidator, type: :model, swars_spec: true do
  let(:key) { "alice-bob-20130531_010024" }
  let(:object) { Swars::BattleKeyValidator.new(key) }

  describe "ClassMethods" do
    it "valid?" do
      assert { Swars::BattleKeyValidator.valid?("alice-bob-20130531_010024") }
    end

    it "invalid?" do
      assert { Swars::BattleKeyValidator.invalid?("xxx") }
    end
  end

  describe "InstanceMethods" do
    it "valid?" do
      assert { Swars::BattleKeyValidator.new(key).valid? }
    end

    it "invalid?" do
      assert { Swars::BattleKeyValidator.new("xxx").invalid? }
    end

    it "validate!" do
      expect { Swars::BattleKeyValidator.new("xxx").validate! }.to raise_error(Swars::BattleKeyValidator::InvalidKey)
    end
  end
end
