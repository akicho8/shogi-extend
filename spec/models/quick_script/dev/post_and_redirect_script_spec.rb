require "rails_helper"

module QuickScript
  RSpec.describe Dev::PostAndRedirectScript, type: :model do
    it "works" do
      assert { Dev::PostAndRedirectScript.new.as_json }
    end
  end
end
