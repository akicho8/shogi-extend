require "rails_helper"

RSpec.describe QuickScript::Dev::ParamsScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::ParamsScript.new.as_json }
  end
end
