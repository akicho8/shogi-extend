require "rails_helper"

module Swars
  module Importer
    RSpec.describe ThrottleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        ThrottleImporter.new(user_key: "DevUser1").call
        assert { Battle.count == 3 }
        ThrottleImporter.new(user_key: "DevUser1").call
        assert { Battle.count == 3 }
      end
    end
  end
end
