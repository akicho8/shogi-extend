require "rails_helper"

module Swars
  module Agent
    RSpec.describe Record, type: :model, swars_spec: true do
      it "development" do
        object = Record.new(key: BattleKey.create("DevUser1-DevUser2-20200101_123456")).fetch
        assert2 { object.dig("gameHash", "name") == "MockUser1-MockUser2-20000101_112233" }
      end
      it "production" do
        object = Record.new(key: BattleKey.create("Kato_Hifumi-SiroChannel-20190317_140844"), remote_run: true).fetch
        assert2 { object.dig("gameHash", "name") == "Kato_Hifumi-SiroChannel-20190317_140844" }
      end
    end
  end
end
