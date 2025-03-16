require "rails_helper"

RSpec.describe Swars::BattleUrlExtractor, type: :model, swars_spec: true do
  let(:battle_key) { Swars::BattleKey.create("alice-bob-20200927_180900") }
  let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
  let(:text) { "棋譜 #{raw_url}" }

  it "battle_url" do
    assert { Swars::BattleUrlExtractor.new(text).battle_url.to_s == raw_url }
  end
end
