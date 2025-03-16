require "rails_helper"

RSpec.describe QuickScript::Dev::TableScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::TableScript.new.as_json }
  end
end
