require "rails_helper"

RSpec.describe QuickScript::Middleware::GeneralApiMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.as_json.has_key?(:json_link) }
    assert { !object.json_link }
  end
end
