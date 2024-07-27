require "rails_helper"

module QuickScript
  RSpec.describe Middleware::RedirectMod, type: :model do
    it "works" do
      object = Dev::NullScript.new
      object.redirect_to("(path)", :something => 1)
      assert { object.as_json[:redirect_to] == { to: "(path)", something: 1 } }
    end
  end
end
