require "rails_helper"

RSpec.describe QuickScript::Dev::FormValueSessionRestoreScript, type: :model do
  it "works" do
    instance = QuickScript::Dev::FormValueSessionRestoreScript.new({str1: "new_value"}).tap(&:as_json)
    assert { instance.session == {"QuickScript::Dev::FormValueSessionRestoreScript" => {"str1" => "new_value", "radio1" => nil}} }
  end
end
