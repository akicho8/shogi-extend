require "rails_helper"

RSpec.describe QuickScript::Dev::IframeScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::IframeScript.new.as_json }
  end
end
