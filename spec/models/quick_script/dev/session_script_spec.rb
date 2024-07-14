require "rails_helper"

module QuickScript
  RSpec.describe Dev::SessionScript, type: :model do
    it "works" do
      assert { Dev::SessionScript.new.as_json }
    end
  end
end
