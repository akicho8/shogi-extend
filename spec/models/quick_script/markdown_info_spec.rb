require "rails_helper"

RSpec.describe QuickScript::MarkdownInfo, type: :model do
  it "works" do
    assert { QuickScript::MarkdownInfo.values.all?(&:markdown_text) }
  end
end
