require "rails_helper"

RSpec.describe QuickScript::Middleware::GeneralApiMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.as_json.has_key?(:general_json_link_show) }
    assert { !object.general_json_link_show }
  end
end
