require "rails_helper"

module Swars
  RSpec.describe BattleUrlValidator, type: :model, swars_spec: true do
    let(:battle_key) { BattleKey.create("alice-bob-20200927_180900") }
    let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
    let(:text) { "棋譜 #{raw_url}" }

    it "valid?" do
      assert { BattleUrlValidator.new(raw_url).valid? }
    end

    it "invalid?" do
      assert { BattleUrlValidator.new(text).invalid? }
    end

    it "validate!" do
      expect { BattleUrlValidator.new(text).validate! }.to raise_error(BattleUrlValidator::InvalidKey)
    end
  end
end
