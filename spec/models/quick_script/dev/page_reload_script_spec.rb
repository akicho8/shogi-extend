require "rails_helper"

module QuickScript
  RSpec.describe Dev::PageReloadScript, type: :model do
    it "works" do
      assert { Dev::PageReloadScript.new.as_json }
    end
  end
end
