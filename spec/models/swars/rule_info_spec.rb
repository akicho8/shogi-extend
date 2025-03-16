require "rails_helper"

RSpec.describe Swars::RuleInfo, type: :model, swars_spec: true do
  it "fetch" do
    assert { Swars::RuleInfo.fetch("ten_min") }
    assert { Swars::RuleInfo.fetch("3分") }
    assert { Swars::RuleInfo.fetch("３分") }
    assert { Swars::RuleInfo.fetch("3分切れ負け") }
  end

  it "将棋ウォーズのダメな仕様で10分のときのキーが空文字列になっている" do
    assert { Swars::RuleInfo.fetch("").name == "10分" }
  end
end
