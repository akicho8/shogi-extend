require "rails_helper"

RSpec.describe QuickScript::Dev::MarkdownScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::MarkdownScript.new.call }
  end
end
