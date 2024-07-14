require "rails_helper"

module QuickScript
  RSpec.describe Dev::HelloScript, type: :model do
    it "works" do
      assert { Dev::HelloScript.new.as_json }
    end
  end
end
