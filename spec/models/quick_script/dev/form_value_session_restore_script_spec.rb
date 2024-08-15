require "rails_helper"

module QuickScript
  RSpec.describe Dev::FormValueSessionRestoreScript, type: :model do
    it "works" do
      instance = Dev::FormValueSessionRestoreScript.new({str1: "new_value"}).tap(&:as_json)
      assert { instance.session == {"QuickScript::Dev::FormValueSessionRestoreScript" => {"str1" => "new_value", "radio1" => nil}} }
    end
  end
end
