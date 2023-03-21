require "rails_helper"

module Swars
  module Importer
    RSpec.describe BattleImporter, type: :model, swars_spec: true do
      it "skip_if_exist: true なので2つ目をスキップしている" do
        key = BattleKeyGenerator.new.generate
        BattleImporter.new(key: key).run
        BattleImporter.new(key: key).run
        is_asserted_by { Battle.count == 1 }
      end

      # https://twitter.com/_B0F9_/status/1606581630243520512
      it "結末を正しく取り込んでいる" do
        key = BattleKeyGenerator.new.generate
        BattleImporter.new(key: key).run
        is_asserted_by { Battle.count == 1 }
        is_asserted_by { Battle.first.final.key == "TIMEOUT" }
      end
    end
  end
end
