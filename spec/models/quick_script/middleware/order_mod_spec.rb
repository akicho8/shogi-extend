require "rails_helper"

RSpec.describe QuickScript::Middleware::OrderMod, type: :model do
  it "works" do
    assert { QuickScript::Dev::NullScript.ordered_index == Float::INFINITY }
    assert { QuickScript::Swars::PrisonAllScript.ordered_index.kind_of?(Integer) }
  end
end
