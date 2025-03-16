require "rails_helper"

RSpec.describe QuickScript::Dev::ErrorScript, type: :model do
  it "works" do
    proc { QuickScript::Dev::ErrorScript.new.call }.should raise_error(ZeroDivisionError)
    assert { QuickScript::Dev::ErrorScript.new(__EXCEPTION_RESCUE__: true).as_json }
  end
end
