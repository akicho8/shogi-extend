require "rails_helper"

module Swars
  module Importer
    RSpec.describe AllRuleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        AllRuleImporter.new(user_key: "DevUser1").run
        assert { Battle.count == 3 }
        AllRuleImporter.new(user_key: "DevUser1").run
        assert { Battle.count == 3 }
      end
    end
  end
end
