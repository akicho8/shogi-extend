require "rails_helper"

module Swars
  module Importer
    RSpec.describe SingleHistoryImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        SingleHistoryImporter.new(user_key: "DevUser1", gtype: "").call
        assert { Battle.count == 3 }
      end
    end
  end
end
