require "rails_helper"

module Swars
  module Importer
    RSpec.describe OneRuleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        OneRuleImporter.new(user_key: "DevUser1", gtype: "").run
        assert { Battle.count == 3 }
      end
    end
  end
end
