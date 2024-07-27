require "rails_helper"

module QuickScript
  RSpec.describe Middleware::FlashMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      assert { object.flash }
      assert { object.as_json.has_key?(:flash) }
    end
  end
end
