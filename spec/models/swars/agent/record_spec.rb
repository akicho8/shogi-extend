require "rails_helper"

RSpec.describe Swars::Agent::Record, type: :model, swars_spec: true do
  it "development" do
    object = Swars::Agent::Record.new(key: Swars::BattleKey.create("DevUser1-DevUser2-20200101_123456")).fetch
    assert { object.dig("gameHash", "name") == "MockUser1-MockUser2-20000101_112233" }
  end
  it "production" do
    object = Swars::Agent::Record.new(key: Swars::BattleKey.create("Kato_Hifumi-SiroChannel-20190317_140844"), remote_run: true).fetch
    assert { object.dig("gameHash", "name") == "Kato_Hifumi-SiroChannel-20190317_140844" }
  end
end
