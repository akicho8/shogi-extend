require "rails_helper"

RSpec.describe QuickScript::General::PreProfessionalLeagueScript, type: :model do
  it "works" do
    json = QuickScript::General::PreProfessionalLeagueScript.new({}, {}).as_json
    assert { json }
  end
end
