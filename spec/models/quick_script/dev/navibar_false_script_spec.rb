require "rails_helper"

module QuickScript
  RSpec.describe Dev::NavibarFalseScript, type: :model do
    it "works" do
      assert { Dev::NavibarFalseScript.new.as_json }
    end
  end
end
