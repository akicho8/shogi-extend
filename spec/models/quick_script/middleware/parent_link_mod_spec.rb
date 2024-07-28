require "rails_helper"

module QuickScript
  RSpec.describe Middleware::ParentLinkMod, type: :model do
    it "works" do
      object = QuickScript::Dev::NullScript.new
      object.parent_link = SecureRandom.hex
      assert { object.as_json[:parent_link] }
    end
  end
end
