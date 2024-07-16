require "rails_helper"

module QuickScript
  RSpec.describe Dev::Fake500Script, type: :model do
    it "works" do
      assert { Dev::Fake500Script.new.as_json }
    end
  end
end
