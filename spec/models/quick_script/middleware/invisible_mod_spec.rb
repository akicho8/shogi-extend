require "rails_helper"

RSpec.describe QuickScript::Middleware::InvisibleMod, type: :model do
  it "works" do
    assert { !QuickScript::Dev::NullScript.qs_invisible }
  end
end
