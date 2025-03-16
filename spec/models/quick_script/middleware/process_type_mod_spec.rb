require "rails_helper"

RSpec.describe QuickScript::Middleware::ProcessTypeMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.axios_process_type == :server }
  end
end
