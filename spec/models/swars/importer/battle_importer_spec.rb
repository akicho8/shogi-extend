require "rails_helper"

module Swars
  module Importer
    RSpec.describe BattleImporter, type: :model, swars_spec: true do
      it "skip_if_exist: true なので2つ目をスキップしている" do
        key = BattleKeyGenerator.new.generate
        BattleImporter.new(key: key).call
        BattleImporter.new(key: key).call
        assert { Battle.count == 1 }
      end

      # https://twitter.com/_B0F9_/status/1606581630243520512
      it "結末を正しく取り込んでいる" do
        key = BattleKeyGenerator.new.generate
        BattleImporter.new(key: key).call
        assert { Battle.count == 1 }
        assert { Battle.first.final.key == "TIMEOUT" }
      end
    end
  end
end
