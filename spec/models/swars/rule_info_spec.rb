require "rails_helper"

module Swars
  RSpec.describe RuleInfo, type: :model do
    it "fetch" do
      assert { RuleInfo.fetch("ten_min") }
      assert { RuleInfo.fetch("3分") }
      assert { RuleInfo.fetch("３分") }
      assert { RuleInfo.fetch("3分切れ負け") }
    end
  end
end
