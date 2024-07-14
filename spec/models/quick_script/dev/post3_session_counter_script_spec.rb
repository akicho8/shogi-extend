require "rails_helper"

module QuickScript
  RSpec.describe Dev::Post3SessionCounterScript, type: :model do
    it "works" do
      assert { Dev::Post3SessionCounterScript.new.as_json }
    end
  end
end
