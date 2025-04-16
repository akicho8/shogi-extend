require "rails_helper"

RSpec.describe QuickScript::General::PiyoShogiConfigScript, type: :model do
  it "works" do
    json = QuickScript::General::PiyoShogiConfigScript.new({}, { _method: "post" }).as_json
    assert { json[:flash][:notice].match?(/保存/) }
  end
end
