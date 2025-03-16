require "rails_helper"

RSpec.describe Swars::Importer::BattleImporter, type: :model, swars_spec: true do
  it "skip_if_exist: true なので2つ目をスキップしている" do
    key = Swars::BattleKeyGenerator.new.generate
    Swars::Importer::BattleImporter.new(key: key).call
    Swars::Importer::BattleImporter.new(key: key).call
    assert { Swars::Battle.count == 1 }
  end

  # https://twitter.com/_B0F9_/status/1606581630243520512
  it "結末を正しく取り込んでいる" do
    key = Swars::BattleKeyGenerator.new.generate
    Swars::Importer::BattleImporter.new(key: key).call
    assert { Swars::Battle.count == 1 }
    assert { Swars::Battle.first.final.key == "TIMEOUT" }
  end

  it "メンバーが2人いる" do
    key = Swars::BattleKeyGenerator.new.generate
    Swars::Importer::BattleImporter.new(key: key).call
    assert { Swars::Battle.first.memberships.count == 2 }
  end
end
