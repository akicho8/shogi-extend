require "rails_helper"

module QuickScript
  RSpec.describe Dev::FlashScript, type: :model do
    it "works" do
      assert { Dev::FlashScript.new.as_json }
    end
  end
end
