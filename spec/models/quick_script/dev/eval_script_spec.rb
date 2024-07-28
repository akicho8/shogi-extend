require "rails_helper"

module QuickScript
  RSpec.describe Dev::EvalScript, type: :model do
    it "works" do
      assert { Dev::EvalScript.new(code: "1 + 2").call == 3 }
    end
  end
end
