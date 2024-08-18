require "rails_helper"

module Swars
  RSpec.describe RuleInfo, type: :model, swars_spec: true do
    it "fetch" do
      assert { RuleInfo.fetch("ten_min") }
      assert { RuleInfo.fetch("3分") }
      assert { RuleInfo.fetch("３分") }
      assert { RuleInfo.fetch("3分切れ負け") }
    end

    it "将棋ウォーズのダメな仕様で10分のときのキーが空文字列になっている" do
      assert { RuleInfo.fetch("").name == "10分" }
    end
  end
end
