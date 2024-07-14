require "rails_helper"

module QuickScript
  RSpec.describe Dev::ErrorScript, type: :model do
    it "works" do
      assert { Dev::ErrorScript.new.as_json }
    end
  end
end
