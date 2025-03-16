require "rails_helper"

RSpec.describe QuickScript::Dev::AbstractScript, type: :model do
  it "works" do
    assert { QuickScript::Dispatcher.all.include?(QuickScript::Dev::NullScript) }
    assert { QuickScript::Dispatcher.all.exclude?(QuickScript::Dev::AbstractScript) }
  end
end
