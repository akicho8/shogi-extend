require "rails_helper"

module Swars
  module Importer
    RSpec.describe BattleImporter, type: :model, swars_spec: true do
      it "works" do
        key = KeyVo.generate
        BattleImporter.new(key: key).run
        BattleImporter.new(key: key).run # skip_if_exist: true なのでスキップしている
        assert { Battle.count == 1 }
      end
    end
  end
end
