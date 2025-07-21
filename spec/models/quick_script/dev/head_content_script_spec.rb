require "rails_helper"

RSpec.describe QuickScript::Dev::HeadContentScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::HeadContentScript.new.to_json.to_s.include?("(head_content)") }
  end
end
