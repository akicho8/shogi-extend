require "rails_helper"

RSpec.describe QuickScript::Admin::SwarsZipDlLogScript, type: :model do
  it "works" do
    object = QuickScript::Admin::SwarsZipDlLogScript.new({}, {})
    assert { object.as_json }
  end
end
