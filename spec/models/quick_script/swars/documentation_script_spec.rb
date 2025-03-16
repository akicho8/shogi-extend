require "rails_helper"

RSpec.describe QuickScript::Swars::DocumentationScript, type: :model do
  it "works" do
    assert { QuickScript::Swars::DocumentationScript.new.call }
  end

  it "継承の継承だけど Dispatcher.all に出てくる" do
    assert { QuickScript::Dispatcher.all.include?(QuickScript::Swars::DocumentationScript) }
  end
end
