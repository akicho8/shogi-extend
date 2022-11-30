require "rails_helper"

module Swars
  RSpec.describe BattleUrl, type: :model, swars_spec: true do
    let(:key) { BattleKey.wrap("alice-bob-20200927_180900") }
    let(:url) { "https://shogiwars.heroz.jp/games/#{key}" }
    let(:text) { "棋譜 #{url}" }

    describe "ClassMethods" do
      it "valid?" do
        assert { BattleUrl.valid?(text) }
      end

      it "invalid?" do
        assert { BattleUrl.invalid?("xxx") }
      end

      it "url" do
        assert { BattleUrl.url(text) == url }
      end

      it "key" do
        assert { BattleUrl.key(text) == key }
      end

      it "user_key" do
        assert { BattleUrl.user_key(text) == "alice" }
      end
    end

    describe "InstanceMethods" do
      it "url" do
        assert { BattleUrl.new(text).url == url }
      end

      it "key" do
        assert { BattleUrl.new(text).key == key }
      end

      it "user_key" do
        assert { BattleUrl.new(text).user_key == "alice" }
      end
    end
  end
end
