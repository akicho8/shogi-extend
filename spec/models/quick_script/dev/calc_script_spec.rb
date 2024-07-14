require "rails_helper"

module QuickScript
  RSpec.describe Dev::CalcScript, type: :model do
    it "works" do
      assert { Dev::CalcScript.new.as_json }
    end
  end
end
