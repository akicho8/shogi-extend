require "rails_helper"

RSpec.describe QuickScript::Middleware::FlashMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.flash }
    assert { object.as_json.has_key?(:flash) }
  end
end
