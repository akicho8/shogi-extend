require "rails_helper"

RSpec.describe QuickScript::General::PreProfessionalLeagueScript, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["1"].users_update({name: "alice"})
    e = QuickScript::General::PreProfessionalLeagueScript.new({user_name: "alice"}, {})
    assert { e.as_general_json["成績行列"].size == 1 }
    assert { e.call }
  end
end
