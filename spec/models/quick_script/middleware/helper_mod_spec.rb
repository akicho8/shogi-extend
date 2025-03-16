require "rails_helper"

RSpec.describe QuickScript::Middleware::HelperMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.tag }
    assert { object.h }
  end
end
