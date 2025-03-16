require "rails_helper"

RSpec.describe Swars::Importer::SingleHistoryImporter, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::Battle.count == 0 }
    Swars::Importer::SingleHistoryImporter.new(user_key: "DevUser1", gtype: "").call
    assert { Swars::Battle.count == 3 }
  end
end
