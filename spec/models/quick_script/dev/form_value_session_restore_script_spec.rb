require "rails_helper"

RSpec.describe QuickScript::Dev::FormValueSessionRestoreScript, type: :model do
  it "works" do
    assert { PermanentVariable.none? }
    instance = QuickScript::Dev::FormValueSessionRestoreScript.new({ str1: "new_value" }, {session_id: SecureRandom.hex}).tap(&:as_json)
    assert { instance.session == {} }
    assert { PermanentVariable.exists? }
  end
end
