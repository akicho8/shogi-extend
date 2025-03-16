require "rails_helper"

RSpec.describe QuickScript::Middleware::SidebarMod, type: :model do
  it "works" do
    json = QuickScript::Dev::NullScript.new.as_json
    assert { json.has_key?(:sideber_menu_show) }
    assert { json.has_key?(:sideber_menu_groups) }
  end
end
