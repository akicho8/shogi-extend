require "rails_helper"

module Swars
  RSpec.describe RuleInfo, type: :model, swars_spec: true do
    it "fetch" do
      assert2 { RuleInfo.fetch("ten_min") }
      assert2 { RuleInfo.fetch("3分") }
      assert2 { RuleInfo.fetch("３分") }
      assert2 { RuleInfo.fetch("3分切れ負け") }
    end
  end
end
