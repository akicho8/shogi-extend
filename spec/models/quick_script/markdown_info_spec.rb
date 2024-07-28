require "rails_helper"

module QuickScript
  RSpec.describe MarkdownInfo, type: :model do
    it "works" do
      assert { MarkdownInfo.values.all?(&:markdown_text) }
    end
  end
end
