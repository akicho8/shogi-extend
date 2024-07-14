require "rails_helper"

module QuickScript
  RSpec.describe Dev::Post1Script, type: :model do
    it "works" do
      assert { Dev::Post1Script.new.as_json }
    end
  end
end
