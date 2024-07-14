require "rails_helper"

module QuickScript
  RSpec.describe Dev::SessionCounterScript, type: :model do
    it "works" do
      assert { Dev::SessionCounterScript.new.as_json }
    end
  end
end
