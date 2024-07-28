require "rails_helper"

module QuickScript
  RSpec.describe Middleware::SidebarMod, type: :model do
    it "works" do
      json = Dev::NullScript.new.as_json
      assert { json.has_key?(:sideber_menu_show) }
      assert { json.has_key?(:sideber_menu_groups) }
    end
  end
end
