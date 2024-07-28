require "rails_helper"

module QuickScript
  RSpec.describe Dev::Redirect3Script, type: :model do
    it "works" do
      assert { Dev::Redirect3Script.new.as_json }
    end
  end
end
