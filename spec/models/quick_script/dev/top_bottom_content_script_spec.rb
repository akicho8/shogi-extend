require "rails_helper"

RSpec.describe QuickScript::Dev::TopBottomContentScript, type: :model do
  it "works" do
    json = QuickScript::Dev::TopBottomContentScript.new.to_json.to_s
    assert { json.include?("(top_content)") }
    assert { json.include?("(call)") }
    assert { json.include?("(bottom_content)") }
  end
end
