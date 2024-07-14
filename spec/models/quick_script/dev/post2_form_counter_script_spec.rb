require "rails_helper"

module QuickScript
  RSpec.describe Dev::Post2FormCounterScript, type: :model do
    it "works" do
      assert { Dev::Post2FormCounterScript.new.as_json }
    end
  end
end
