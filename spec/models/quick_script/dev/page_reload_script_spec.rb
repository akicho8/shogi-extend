require "rails_helper"

RSpec.describe QuickScript::Dev::PageReloadScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::PageReloadScript.new.as_json }
  end
end
