require "rails_helper"

module QuickScript
  RSpec.describe Dev::ValueScript, type: :model do
    it "works" do
      assert { Dev::ValueScript.new.as_json }
    end
  end
end
