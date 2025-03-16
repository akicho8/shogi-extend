require "rails_helper"

RSpec.describe QuickScript::Dev::SidebarScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::SidebarScript.new.as_json }
  end
end
