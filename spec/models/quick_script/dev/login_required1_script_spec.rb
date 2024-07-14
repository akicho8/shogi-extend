require "rails_helper"

module QuickScript
  RSpec.describe Dev::LoginRequired1Script, type: :model do
    it "works" do
      assert { Dev::LoginRequired1Script.new.as_json }
    end
  end
end
