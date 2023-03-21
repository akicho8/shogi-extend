require "rails_helper"

module Swars
  RSpec.describe BattleKeyValidator, type: :model, swars_spec: true do
    let(:key) { "alice-bob-20130531_010024" }
    let(:object) { BattleKeyValidator.new(key) }

    describe "ClassMethods" do
      it "valid?" do
        is_asserted_by { BattleKeyValidator.valid?("alice-bob-20130531_010024") }
      end

      it "invalid?" do
        is_asserted_by { BattleKeyValidator.invalid?("xxx") }
      end
    end

    describe "InstanceMethods" do
      it "valid?" do
        is_asserted_by { BattleKeyValidator.new(key).valid? }
      end

      it "invalid?" do
        is_asserted_by { BattleKeyValidator.new("xxx").invalid? }
      end

      it "validate!" do
        expect { BattleKeyValidator.new("xxx").validate! }.to raise_error(BattleKeyValidator::InvalidKey)
      end
    end
  end
end
