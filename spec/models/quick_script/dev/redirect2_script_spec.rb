require "rails_helper"

module QuickScript
  RSpec.describe Dev::Redirect2Script, type: :model do
    it "works" do
      assert { Dev::Redirect2Script.new.as_json }
    end
  end
end
