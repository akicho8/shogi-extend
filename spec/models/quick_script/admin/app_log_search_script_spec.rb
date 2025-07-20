require "rails_helper"

RSpec.describe QuickScript::Admin::AppLogSearchScript, type: :model do
  it "works" do
    hex = SecureRandom.hex
    app_log = AppLog.create!(body: hex)
    object = QuickScript::Admin::AppLogSearchScript.new({query: hex}, {})
    assert { object.call.to_s.include?(hex) }
  end
end
