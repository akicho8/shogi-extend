require "rails_helper"

module QuickScript
  RSpec.describe Dev::InvalidateBasicAuthScript, type: :model do
    it "works" do
      assert { Dev::InvalidateBasicAuthScript.new.as_json }
    end
  end
end
