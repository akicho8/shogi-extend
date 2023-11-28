require "rails_helper"

module Swars
  RSpec.describe BattleUrl, type: :model, swars_spec: true do
    let(:battle_key) { BattleKey.create("alice-bob-20200927_180900") }
    let(:raw_url) { "https://shogiwars.heroz.jp/games/#{battle_key}" }
    let(:text) { "棋譜 #{url}" }

    it "battle_key" do
      assert { BattleUrl.new(raw_url).battle_key == battle_key }
    end

    it "user_key" do
      assert { BattleUrl.new(raw_url).user_key == "alice" }
    end

    it "to_s" do
      assert { BattleUrl.new(raw_url).to_s == raw_url }
    end
  end
end
