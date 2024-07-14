require "rails_helper"

module QuickScript
  RSpec.describe Dev::FormScript, type: :model do
    it "works" do
      assert { Dev::FormScript.new.as_json }
    end
  end
end
