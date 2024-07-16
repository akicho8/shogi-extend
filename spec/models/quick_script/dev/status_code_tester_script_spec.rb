require "rails_helper"

module QuickScript
  RSpec.describe Dev::StatusCodeTesterScript, type: :model do
    it "works" do
      assert { Dev::StatusCodeTesterScript.new.as_json }
    end
  end
end
