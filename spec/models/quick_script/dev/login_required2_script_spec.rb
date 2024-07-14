require "rails_helper"

module QuickScript
  RSpec.describe Dev::LoginRequired2Script, type: :model do
    it "works" do
      assert { Dev::LoginRequired2Script.new.as_json }
    end
  end
end
