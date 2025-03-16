require "rails_helper"

RSpec.describe QuickScript::Dev::DelegateScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::DelegateScript.new.call }
  end
end
