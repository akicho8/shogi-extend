require "rails_helper"

RSpec.describe Swars::Importer::ThrottleImporter, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::Battle.count == 0 }
    Swars::Importer::ThrottleImporter.new(user_key: "DevUser1").call
    assert { Swars::Battle.count == 3 }
    Swars::Importer::ThrottleImporter.new(user_key: "DevUser1").call
    assert { Swars::Battle.count == 3 }
  end
end
