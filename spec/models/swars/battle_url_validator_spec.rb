require "rails_helper"

RSpec.describe Swars::BattleUrlValidator, type: :model, swars_spec: true do
  let(:battle_key) { Swars::BattleKey.create("alice-bob-20200927_180900") }
  let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
  let(:text) { "棋譜 #{raw_url}" }

  it "valid?" do
    assert { Swars::BattleUrlValidator.new(raw_url).valid? }
  end

  it "invalid?" do
    assert { Swars::BattleUrlValidator.new(text).invalid? }
  end

  it "validate!" do
    expect { Swars::BattleUrlValidator.new(text).validate! }.to raise_error(Swars::BattleUrlValidator::InvalidKey)
  end
end
