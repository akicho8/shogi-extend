require "rails_helper"

RSpec.describe QuickScript::Swars::BattleHistoryScript, type: :model do
  it "works" do
    current_user = User.create!
    swars_user = ::Swars::User.create!
    ::Swars::Battle.create! do |e|
      e.memberships.build(user: swars_user)
    end
    QuickScript::Swars::BattleHistoryScript.new({}, { current_user: current_user }).call
    Timecop.return do
      QuickScript::Swars::BattleHistoryScript.new({ query: swars_user.key, google_sheet: "true", bg_request: true }, { current_user: current_user, _method: "post" }).call
      assert { GoogleApi::ExpirationTracker.count == 1 }
      GoogleApi::ExpirationTracker.destroy_all
    end
  end
end
