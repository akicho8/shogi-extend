require "rails_helper"

module QuickScript
  RSpec.describe MetaMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.as_json[:meta] }
    end
  end
end
