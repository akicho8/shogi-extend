require "rails_helper"

RSpec.describe QuickScript::MetaMod, type: :model do
  it "works" do
    object = QuickScript::Dev::NullScript.new
    assert { object.as_json[:meta] }
  end

  it "og_image_key_default" do
    assert { QuickScript::Dev::NullScript.og_image_key_default == :application }
    assert { QuickScript::Chore::NullScript.og_image_key_default == "quick_script/chore/null_script" }
  end
end
