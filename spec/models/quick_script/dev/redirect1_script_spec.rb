require "rails_helper"

module QuickScript
  RSpec.describe Dev::Redirect1Script, type: :model do
    it "works" do
      assert { Dev::Redirect1Script.new.as_json }
    end
  end
end
