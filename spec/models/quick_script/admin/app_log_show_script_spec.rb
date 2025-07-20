require "rails_helper"

RSpec.describe QuickScript::Admin::AppLogShowScript, type: :model do
  it "works" do
    app_log = AppLog.create!
    object = QuickScript::Admin::AppLogShowScript.new({id: app_log.id}, {})
    assert { object.as_json }
  end
end
