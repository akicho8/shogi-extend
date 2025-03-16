require "rails_helper"

RSpec.describe QuickScript::Dev::SleepScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::SleepScript.new.as_json }
  end
end
