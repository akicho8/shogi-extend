require "rails_helper"

module Swars
  RSpec.describe BattleUrlExtractor, type: :model, swars_spec: true do
    let(:battle_key) { BattleKey.create("alice-bob-20200927_180900") }
    let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
    let(:text) { "棋譜 #{raw_url}" }

    it "battle_url" do
      is_asserted_by { BattleUrlExtractor.new(text).battle_url.to_s == raw_url }
    end
  end
end
