require "rails_helper"

RSpec.describe QuickScript::Admin::SwarsAgentScript, type: :model do
  it "works" do
    assert { QuickScript::Admin::SwarsAgentScript.new.call }
  end
end
