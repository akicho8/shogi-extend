require "rails_helper"

module QuickScript
  RSpec.describe Dev::InvisibleScript, type: :model do
    it "works" do
      assert { Dev::InvisibleScript.new.as_json }
    end
  end
end
