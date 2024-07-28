require "rails_helper"

module QuickScript
  RSpec.describe Dev::SidebarScript, type: :model do
    it "works" do
      assert { Dev::SidebarScript.new.as_json }
    end
  end
end
