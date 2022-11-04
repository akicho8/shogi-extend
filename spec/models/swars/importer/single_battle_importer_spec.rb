require "rails_helper"

module Swars
  module Importer
    RSpec.describe SingleBattleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        SingleBattleImporter.new(key: "Kotakota3-StarCerisier-20200815_213555").run
        assert { Battle.count == 1 }
      end
    end
  end
end
