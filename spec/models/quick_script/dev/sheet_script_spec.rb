require "rails_helper"

module QuickScript
  RSpec.describe Dev::SheetScript, type: :model do
    it "works" do
      assert { Dev::SheetScript.new.as_json }
    end
  end
end
