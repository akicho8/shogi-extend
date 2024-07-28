require "rails_helper"

module QuickScript
  RSpec.describe Dev::ParamsScript, type: :model do
    it "works" do
      assert { Dev::ParamsScript.new.as_json }
    end
  end
end
