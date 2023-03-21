require "rails_helper"

module Swars
  RSpec.describe RuleInfo, type: :model, swars_spec: true do
    it "fetch" do
      is_asserted_by { RuleInfo.fetch("ten_min") }
      is_asserted_by { RuleInfo.fetch("3分") }
      is_asserted_by { RuleInfo.fetch("３分") }
      is_asserted_by { RuleInfo.fetch("3分切れ負け") }
    end
  end
end
