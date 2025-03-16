require "rails_helper"

RSpec.describe QuickScript::Dev::SheetScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::SheetScript.new.as_json }
  end
end
