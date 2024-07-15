require "rails_helper"

module QuickScript
  RSpec.describe Chore::StatusCodeScript, type: :model do
    it "works" do
      assert { Chore::StatusCodeScript.new(status_code: 500).call == 500 }
    end
  end
end
