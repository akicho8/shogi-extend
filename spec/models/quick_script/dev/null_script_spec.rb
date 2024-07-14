require "rails_helper"

module QuickScript
  RSpec.describe Dev::NullScript, type: :model do
    it "works" do
      assert { Dev::NullScript.new.as_json }
    end
  end
end
