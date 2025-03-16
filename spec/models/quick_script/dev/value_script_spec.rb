require "rails_helper"

RSpec.describe QuickScript::Dev::ValueScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::ValueScript.new.as_json }
  end
end
