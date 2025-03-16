require "rails_helper"

RSpec.describe QuickScript::Dev::FormScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::FormScript.new.as_json }
  end
end
